from sqlalchemy import Column, Integer, String, DateTime
from . import Base

class APIToken(Base):
    __tablename__ = 'api_tokens'
    TokenID = Column(Integer, primary_key=True)
    Token = Column(String(255), nullable=False)
    ExpiryDate = Column(DateTime, nullable=False)
