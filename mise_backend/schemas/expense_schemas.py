from pydantic import BaseModel
from datetime import date  as dt_date

class ExpenseCreate(BaseModel):
    amount: float
    category: str
    date: dt_date | None = None
    is_shared: int = 0

class AffordRequest(BaseModel):
    item_cost: float
    monthly_income: float
    fixed_expenses: float
    current_savings: float
