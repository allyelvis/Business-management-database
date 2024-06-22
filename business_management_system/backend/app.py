from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from utils.token_manager import TokenManager
from utils.http_post import http_post
import os

app = Flask(__name__)
app.config.from_object('config.Config')

db = SQLAlchemy(app)

# Import models
from models import user, transaction, account, invoice, pos, stock_movement, tax, api_token

# Define routes
@app.route('/')
def home():
    return "Welcome to the Business Management System"

if __name__ == '__main__':
    app.run(debug=True)
