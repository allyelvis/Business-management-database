from sqlalchemy import Column, Integer, String, Float
from . import Base

class Product(Base):
    __tablename__ = 'products'
    ProductID = Column(Integer, primary_key=True)
    ProductName = Column(String(100), nullable=False)
    Category = Column(String(50), nullable=False)
    Price = Column(Float, nullable=False)
    StockQuantity = Column(Integer, nullable=False)
