from sqlalchemy import Column, Integer, Float, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from db import Base
from datetime import date

class Expense(Base):
    __tablename__ = "expenses"

    id = Column(Integer, primary_key=True, index=True)
    amount = Column(Float, nullable=False)
    category = Column(String, nullable=False)
    date = Column(Date, default=date.today)
    is_shared = Column(Integer, default=0)  # 0 = personal, 1 = shared

class Group(Base):
    __tablename__ = "groups"

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    
    # Relationship to easily access all expenses tied to this group
    shared_expenses = relationship("SharedExpense", back_populates="group")

class SharedExpense(Base):
    __tablename__ = "shared_expenses"

    id = Column(Integer, primary_key=True)
    group_id = Column(Integer, ForeignKey("groups.id"))
    paid_by = Column(String, nullable=False) # Consider using a User ID here later
    amount = Column(Float, nullable=False)
    description = Column(String)
    date = Column(Date, default=date.today)

    group = relationship("Group", back_populates="shared_expenses")