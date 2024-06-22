-- SQL Script to Create Business Management, Financial Accounting, and POS System Database

CREATE DATABASE IF NOT EXISTS business_management;

USE business_management;

-- Create Users and Roles
CREATE TABLE roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(50)
);

CREATE TABLE users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100),
    Password VARCHAR(100),
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES roles(RoleID)
);

-- Create Financial Tables
CREATE TABLE accounts (
    AccountID INT PRIMARY KEY,
    AccountName VARCHAR(100),
    AccountType VARCHAR(50),
    Balance DECIMAL(10, 2)
);

CREATE TABLE transactions (
    TransactionID INT PRIMARY KEY,
    UserID INT,
    TransactionDate DATETIME,
    TransactionAmount DECIMAL(10, 2),
    TransactionType VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

CREATE TABLE journal_entries (
    EntryID INT PRIMARY KEY,
    AccountID INT,
    Date DATETIME,
    Amount DECIMAL(10, 2),
    Description VARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES accounts(AccountID)
);

CREATE TABLE invoices (
    InvoiceID INT PRIMARY KEY,
    CustomerID INT,
    Date DATETIME,
    Amount DECIMAL(10, 2),
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

CREATE TABLE invoice_items (
    InvoiceItemID INT PRIMARY KEY,
    InvoiceID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (InvoiceID) REFERENCES invoices(InvoiceID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

CREATE TABLE billing (
    BillingID INT PRIMARY KEY,
    InvoiceID INT,
    AmountPaid DECIMAL(10, 2),
    PaymentDate DATETIME,
    PaymentMethodID INT,
    FOREIGN KEY (InvoiceID) REFERENCES invoices(InvoiceID),
    FOREIGN KEY (PaymentMethodID) REFERENCES payment_methods(PaymentMethodID)
);

-- Create POS Tables
CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

CREATE TABLE sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATETIME,
    SaleAmount DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

CREATE TABLE pos_transactions (
    POSTransactionID INT PRIMARY KEY,
    SaleID INT,
    TransactionDate DATETIME,
    PaymentMethodID INT,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (SaleID) REFERENCES sales(SaleID),
    FOREIGN KEY (PaymentMethodID) REFERENCES payment_methods(PaymentMethodID)
);

CREATE TABLE payment_methods (
    PaymentMethodID INT PRIMARY KEY,
    MethodName VARCHAR(50)
);

-- Create Restaurant POS Tables
CREATE TABLE menu_items (
    MenuItemID INT PRIMARY KEY,
    ItemName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    TableID INT,
    MenuItemID INT,
    Quantity INT,
    OrderDate DATETIME,
    Status VARCHAR(50),
    FOREIGN KEY (TableID) REFERENCES tables(TableID),
    FOREIGN KEY (MenuItemID) REFERENCES menu_items(MenuItemID)
);

CREATE TABLE tables (
    TableID INT PRIMARY KEY,
    TableName VARCHAR(50),
    Capacity INT
);

-- Create Retail Store Tables
CREATE TABLE inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    LastRestockDate DATETIME,
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

CREATE TABLE sales_retail (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATETIME,
    SaleAmount DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- Create Hospital Management Tables
CREATE TABLE patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    DateOfBirth DATE,
    ContactDetails VARCHAR(255),
    MedicalHistory TEXT
);

CREATE TABLE appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Status VARCHAR(50),
    FOREIGN KEY (PatientID) REFERENCES patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES doctors(DoctorID)
);

CREATE TABLE doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100),
    Specialty VARCHAR(50),
    ContactDetails VARCHAR(255)
);

CREATE TABLE hospital_transactions (
    TransactionID INT PRIMARY KEY,
    PatientID INT,
    TransactionDate DATETIME,
    Amount DECIMAL(10, 2),
    ServiceType VARCHAR(100),
    FOREIGN KEY (PatientID) REFERENCES patients(PatientID)
);

-- Create Stock Movement Table
CREATE TABLE stock_movements (
    StockMovementID INT PRIMARY KEY,
    ProductID INT,
    MovementType VARCHAR(50),
    Quantity INT,
    MovementDate DATETIME,
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- Create Tax Table
CREATE TABLE taxes (
    TaxID INT PRIMARY KEY,
    TaxName VARCHAR(100),
    Rate DECIMAL(5, 2)
);

-- Create Fiscalization Tables
CREATE TABLE fiscal_transactions (
    FiscalTransactionID INT PRIMARY KEY,
    TransactionID INT,
    FiscalizationDate DATETIME,
    FiscalCode VARCHAR(50),
    FOREIGN KEY (TransactionID) REFERENCES transactions(TransactionID)
);

CREATE TABLE fiscal_codes (
    FiscalCodeID INT PRIMARY KEY,
    Code VARCHAR(50),
    Description VARCHAR(255)
);

-- Create API Token Table
CREATE TABLE api_tokens (
    TokenID INT PRIMARY KEY,
    Token VARCHAR(255),
    ExpiryDate DATETIME
);

-- Procedure to Post Transaction
DELIMITER //

CREATE PROCEDURE post_transaction(IN transaction_data TEXT)
BEGIN
    DECLARE response TEXT;
    DECLARE url TEXT DEFAULT 'http://localhost:5000/post_transaction';

    SET response = http_post(url, transaction_data);
    IF response IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'HTTP POST failed';
    END IF;
END//

-- Trigger to Post Invoice Transaction
CREATE TRIGGER after_invoice_insert
AFTER INSERT ON invoices
FOR EACH ROW
BEGIN
    DECLARE transaction_json TEXT;
    SET transaction_json = JSON_OBJECT(
        'InvoiceID', NEW.InvoiceID,
        'CustomerID', NEW.CustomerID,
        'Date', NEW.Date,
        'Amount', NEW.Amount,
        'Status', NEW.Status
    );

    CALL post_transaction(transaction_json);
END//

-- Trigger to Post Stock Movement
CREATE TRIGGER after_stock_movement_insert
AFTER INSERT ON stock_movements
FOR EACH ROW
BEGIN
    DECLARE transaction_json TEXT;
    SET transaction_json = JSON_OBJECT(
        'StockMovementID', NEW.StockMovementID,
        'ProductID', NEW.ProductID,
        'MovementType', NEW.MovementType,
        'Quantity', NEW.Quantity,
        'MovementDate', NEW.MovementDate
    );

    CALL post_transaction(transaction_json);
END//

DELIMITER ;
