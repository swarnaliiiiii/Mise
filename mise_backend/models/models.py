from sqlalchemy import Column, Integer, Float, String, Date
from db import Base
from datetime import date

class Expense(Base):
    __tablename__ = "expenses"

    id = Column(Integer, primary_key=True, index=True)
    amount = Column(Float, nullable=False)
    category = Column(String, nullable=False)
    date = Column(Date, default=date.today)
    is_shared = Column(Integer, default=0)  # 0 = personal, 1 = shared
