from sqlalchemy import Column, Integer, DateTime, Float, String, ForeignKey
from . import Base

class Transaction(Base):
    __tablename__ = 'transactions'
    TransactionID = Column(Integer, primary_key=True)
    UserID = Column(Integer, ForeignKey('users.UserID'))
    TransactionDate = Column(DateTime, nullable=False)
    TransactionAmount = Column(Float, nullable=False)
    TransactionType = Column(String(50), nullable=False)
