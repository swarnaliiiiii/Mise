from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

from db import Base, engine, SessionLocal
from schemas.expense_schemas import ExpenseCreate, AffordRequest
from services.expenses_services import add_expense, monthly_spend
from services.affordibility import when_can_i_afford

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Smart Finance App")

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
