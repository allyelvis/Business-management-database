from marshmallow import Schema, fields

class UserSchema(Schema):
    id = fields.Int(dump_only=True)
    username = fields.Str(required=True)
    password = fields.Str(required=True)

class ProductSchema(Schema):
    id = fields.Int(dump_only=True)
    name = fields.Str(required=True)
    price = fields.Float(required=True)

class CustomerSchema(Schema):
    id = fields.Int(dump_only=True)
    name = fields.Str(required=True)
    email = fields.Email(required=True)

class OrderSchema(Schema):
    id = fields.Int(dump_only=True)
    customer_id = fields.Int(required=True)
    total = fields.Float(required=True)

class InventorySchema(Schema):
    product_id = fields.Int(required=True)
    quantity = fields.Int(required=True)

class SaleSchema(Schema):
    id = fields.Int(dump_only=True)
    customer_id = fields.Int(required=False)
    total_amount = fields.Float(required=True)
    date = fields.DateTime(required=True)
