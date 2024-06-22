from sqlalchemy import Column, Integer, DateTime, Float, String, ForeignKey
from . import Base

class Invoice(Base):
    __tablename__ = 'invoices'
    InvoiceID = Column(Integer, primary_key=True)
    CustomerID = Column(Integer, ForeignKey('customers.CustomerID'))
    Date = Column(DateTime, nullable=False)
    Amount = Column(Float, nullable=False)
    Status = Column(String(50), nullable=False)
