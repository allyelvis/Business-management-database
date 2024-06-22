from sqlalchemy import Column, Integer, String, Float
from . import Base

class Tax(Base):
    __tablename__ = 'taxes'
    TaxID = Column(Integer, primary_key=True)
    TaxName = Column(String(100), nullable=False)
    Rate = Column(Float, nullable=False)
