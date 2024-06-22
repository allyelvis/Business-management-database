from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from . import Base

class StockMovement(Base):
    __tablename__ = 'stock_movements'
    StockMovementID = Column(Integer, primary_key=True)
    ProductID = Column(Integer, ForeignKey('products.ProductID'))
    MovementType = Column(String(50), nullable=False)
    Quantity = Column(Integer, nullable=False)
    MovementDate = Column(DateTime, nullable=False)
