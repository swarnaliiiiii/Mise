from sqlalchemy.orm import Session
from models import Group, SharedExpense
from datetime import date
from collections import defaultdict

def create_group(db: Session, name: str):
    group = Group(name=name)
    db.add(group)
    db.commit()
    db.refresh(group)
    return group

def add_shared_expense(db: Session, expense):
    db_expense = SharedExpense(
        group_id=expense.group_id,
        paid_by=expense.paid_by,
        amount=expense.amount,
        description=expense.description,
        date=expense.date or date.today()
    )
    db.add(db_expense)
    db.commit()
    return db_expense

def calculate_balances(db: Session, group_id: int):
    expenses = db.query(SharedExpense).filter(
        SharedExpense.group_id == group_id
    ).all()

    balances = defaultdict(float)

    for e in expenses:
        balances[e.paid_by] += e.amount

    total = sum(e.amount for e in expenses)
    members = list(balances.keys())
    split = total / len(members)

    net = {}
    for m in members:
        net[m] = round(balances[m] - split, 2)

    return net
