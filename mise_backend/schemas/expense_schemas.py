from pydantic import BaseModel
from datetime import date  as dt_date
from typing import List

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

class GroupCreate(BaseModel):
    name: str

class SharedExpenseCreate(BaseModel):
    group_id: int
    paid_by: str
    amount: float
    participants: List[str]
    description: str | None = None
    date: dt_date | None = None
