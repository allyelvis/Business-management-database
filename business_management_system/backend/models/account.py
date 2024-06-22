from sqlalchemy import Column, Integer, String, Float
from . import Base

class Account(Base):
    __tablename__ = 'accounts'
    AccountID = Column(Integer, primary_key=True)
    AccountName = Column(String(100), nullable=False)
    AccountType = Column(String(50), nullable=False)
    Balance = Column(Float, nullable=False)
