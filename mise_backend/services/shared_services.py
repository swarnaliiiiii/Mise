from sqlalchemy.orm import Session
from models.models import Group, SharedExpense
from datetime import date
from collections import defaultdict

def create_group(db: Session, name: str):
    print(f"[DEBUG] Creating group with name: {name}")
    
    group = Group(name=name)
    db.add(group)
    db.commit()
    db.refresh(group)

    print(f"[DEBUG] Group created with ID: {group.id}")
    return group


def add_shared_expense(db: Session, expense):
    print("[DEBUG] Adding shared expense")
    print(f"[DEBUG] Group ID: {expense.group_id}")
    print(f"[DEBUG] Paid By: {expense.paid_by}")
    print(f"[DEBUG] Amount: {expense.amount}")
    print(f"[DEBUG] Description: {expense.description}")
    print(f"[DEBUG] Date: {expense.date}")

    db_expense = SharedExpense(
        group_id=expense.group_id,
        paid_by=expense.paid_by,
        amount=expense.amount,
        description=expense.description,
        date=expense.date or date.today()
    )

    db.add(db_expense)
    db.commit()
    db.refresh(db_expense)

    print(f"[DEBUG] Expense saved with ID: {db_expense.id}")
    return db_expense


def calculate_balances(db: Session, group_id: int):
    print(f"[DEBUG] Calculating balances for Group ID: {group_id}")

    expenses = db.query(SharedExpense).filter(
        SharedExpense.group_id == group_id
    ).all()

    print(f"[DEBUG] Total expenses fetched: {len(expenses)}")

    balances = defaultdict(float)

    for e in expenses:
        print(f"[DEBUG] Processing expense -> Paid By: {e.paid_by}, Amount: {e.amount}")
        balances[e.paid_by] += e.amount

    total = sum(e.amount for e in expenses)
    print(f"[DEBUG] Total amount spent: {total}")

    members = list(balances.keys())
    print(f"[DEBUG] Members involved: {members}")

    if not members:
        print("[DEBUG] No members found. Returning empty balances.")
        return {}

    split = total / len(members)
    print(f"[DEBUG] Each member should pay: {split}")

    net = {}
    for m in members:
        net[m] = round(balances[m] - split, 2)
        print(f"[DEBUG] Net balance for {m}: {net[m]}")

    print(f"[DEBUG] Final balances: {net}")
    return net