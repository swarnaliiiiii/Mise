from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

from db import Base, engine, SessionLocal
from schemas.expense_schemas import ExpenseCreate, AffordRequest, GroupCreate, SharedExpenseCreate
from services.expenses_services import add_expense, monthly_spend
from services.affordibility import when_can_i_afford
from services.shared_services import (
    create_group,
    add_shared_expense,
    calculate_balances
)
from fastapi.middleware.cors import CORSMiddleware



Base.metadata.create_all(bind=engine)

app = FastAPI(title="Smart Finance App")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/expense")
def create_expense(expense: ExpenseCreate, db: Session = Depends(get_db)):
    return add_expense(db, expense)

@app.get("/spend/monthly")
def get_monthly_spend(db: Session = Depends(get_db)):
    return {"total_spent": monthly_spend(db)}

@app.post("/affordability")
def affordability(req: AffordRequest):
    return when_can_i_afford(
        req.item_cost,
        req.monthly_income,
        req.fixed_expenses,
        req.current_savings
    )

@app.post("/groups")
def create_group_api(group: GroupCreate, db: Session = Depends(get_db)):
    return create_group(db, group.name)

@app.post("/shared-expense")
def add_shared_expense_api(expense: SharedExpenseCreate, db: Session = Depends(get_db)):
    return add_shared_expense(db, expense)

@app.get("/groups/{group_id}/balances")
def get_group_balances(group_id: int, db: Session = Depends(get_db)):
    return calculate_balances(db, group_id)

