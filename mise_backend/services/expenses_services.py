from sqlalchemy.orm import Session
from models.models import Expense
from datetime import date

def add_expense(db: Session, expense):
    db_expense = Expense(
        amount=expense.amount,
        category=expense.category,
        date=expense.date or date.today(),
        is_shared=expense.is_shared
    )
    db.add(db_expense)
    db.commit()
    db.refresh(db_expense)
    return db_expense

def monthly_spend(db: Session):
    expenses = db.query(Expense).all()
    return sum(e.amount for e in expenses)
