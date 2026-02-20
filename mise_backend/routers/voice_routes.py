import re
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from services.expenses_services import add_expense
from db import get_db


router = APIRouter()

class VoiceRequest(BaseModel):
    text: str


# ------------------------
# SMART HELPERS
# ------------------------

def normalize_text(text: str):
    text = text.lower()

    # Fix common voice misrecognitions
    corrections = {
        "expands": "expense",
        "expanse": "expense",
        "expensive": "expense",
        "spilt": "split",
        "slipt": "split",
    }

    for wrong, correct in corrections.items():
        text = text.replace(wrong, correct)

    return text


def extract_number(text: str):
    # First try digit extraction
    digit_match = re.search(r"\d+", text)
    if digit_match:
        return float(digit_match.group())

    # Word numbers
    word_map = {
        "one": 1, "two": 2, "three": 3, "four": 4,
        "five": 5, "six": 6, "seven": 7, "eight": 8,
        "nine": 9, "ten": 10, "hundred": 100,
        "thousand": 1000
    }

    total = 0
    for word in text.split():
        if word in word_map:
            total += word_map[word]

    return float(total) if total > 0 else None


def detect_intent(text: str):
    if "split" in text:
        return "split"
    if "expense" in text or "spent" in text:
        return "personal"
    return None


# ------------------------
# MAIN ROUTE
# ------------------------

@router.post("/voice-expense")
async def process_voice_expense(request: VoiceRequest, db: Session = Depends(get_db)):

    print("\n[DEBUG] ===== SMART VOICE PARSER START =====")
    print(f"[DEBUG] Raw: {request.text}")

    text = normalize_text(request.text)
    print(f"[DEBUG] Normalized: {text}")

    intent = detect_intent(text)
    print(f"[DEBUG] Detected Intent: {intent}")

    amount = extract_number(text)
    print(f"[DEBUG] Extracted Amount: {amount}")

    if not intent or not amount:
        raise HTTPException(
            status_code=400,
            detail="Could not understand command"
        )

    # ------------------------
    # SPLIT HANDLING
    # ------------------------
    if intent == "split":

        # Case 1: split 500 with riya
        match = re.search(r"split .*?(\w+)", text.split("with")[-1])
        if "with" in text and match:
            name = match.group(1).capitalize()
            return {
                "status": "success",
                "type": "split",
                "data": {"name": name, "amount": amount}
            }

        # Case 2: riya and me split 500
        match = re.search(r"(\w+) .*? split", text)
        if match:
            name = match.group(1).capitalize()
            return {
                "status": "success",
                "type": "split",
                "data": {"name": name, "amount": amount}
            }

        raise HTTPException(status_code=400, detail="Split command unclear")

    # ------------------------
    # PERSONAL EXPENSE
    # ------------------------
    if intent == "personal":

        match = re.search(r"spent .*? on (\w+)", text)
        if match:
            category = match.group(1).capitalize()
        else:
            words = text.split()
            category = None
            for i, w in enumerate(words):
                if w in ["expense", "spent"] and i + 1 < len(words):
                    category = words[i + 1]
                    break

        if not category:
            category = "General"

        # 🔥 CREATE EXPENSE OBJECT
        class ExpenseInput:
            def __init__(self, amount, category):
                self.amount = amount
                self.category = category
                self.date = None
                self.is_shared = False

        expense_data = ExpenseInput(
            amount=amount,
            category=category.capitalize()
        )

        db_expense = add_expense(db, expense_data)

        return {
            "status": "success",
            "type": "personal",
            "data": {
                "id": db_expense.id,
                "category": db_expense.category,
                "amount": db_expense.amount
            }
        }

    raise HTTPException(status_code=400, detail="Invalid command")