import re
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class VoiceRequest(BaseModel):
    text: str

@app.post("/voice-expense")
async def process_voice_expense(request: VoiceRequest):
    text = request.text.lower()
    
    # Pattern 1: Split with [Friend] [Amount]
    split_match = re.search(r"split with (\w+)\D*(\d+)", text)
    
    # Pattern 2: Add expense [Category] [Amount]
    # Example: "add expense food 5000"
    expense_match = re.search(r"add expense (\w+)\D*(\d+)", text)

    if split_match:
        name, amount = split_match.group(1).capitalize(), float(split_match.group(2))
        # Logic to save to 'Shared/Friends' table
        return {"status": "success", "type": "split", "data": {"name": name, "amount": amount}}

    if expense_match:
        category, amount = expense_match.group(1).capitalize(), float(expense_match.group(2))
        # Logic to save to your main 'Expenses' table
        return {"status": "success", "type": "personal", "data": {"category": category, "amount": amount}}

    raise HTTPException(status_code=400, detail="Try 'Add expense [Category] [Amount]' or 'Split with [Name] [Amount]'")