from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from . import Base

class Role(Base):
    __tablename__ = 'roles'
    RoleID = Column(Integer, primary_key=True)
    RoleName = Column(String(50), nullable=False)

class User(Base):
    __tablename__ = 'users'
    UserID = Column(Integer, primary_key=True)
    UserName = Column(String(100), nullable=False)
    Password = Column(String(100), nullable=False)
    RoleID = Column(Integer, ForeignKey('roles.RoleID'))
    
    role = relationship('Role', backref='users')
