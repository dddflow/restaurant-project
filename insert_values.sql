-- PEOPLE
INSERT INTO people (id, name, gender, email, phone) VALUES (1001, 'Alice Cust', 'F', 'alice.cust@gmail.com', '9000001');
INSERT INTO people (id, name, gender, email, phone) VALUES (1002, 'John Smith', 'M', 'john.smith@gmail.com', '9000002');
INSERT INTO people (id, name, gender, email, phone) VALUES (1003, 'Maria Petrova', 'F', 'maria.petrova@gmail.com', '9000003');

INSERT INTO people (id, name, gender, email, phone) VALUES (2001, 'Bob Waiter', 'M', 'bob.waiter@gmail.com', '8000001');
INSERT INTO people (id, name, gender, email, phone) VALUES (2002, 'Lina Server', 'F', 'lina.server@gmail.com', '8000002');

INSERT INTO people (id, name, gender, email, phone) VALUES (3001, 'Vova Sup', 'M', 'vova.sup@gmail.com', '7000001');
INSERT INTO people (id, name, gender, email, phone) VALUES (3002, 'Anna Deliv', 'F', 'anna.deliv@gmail.com', '7000002');

-- CUSTOMERS
INSERT INTO customers (id, discount) VALUES (1001, 15.00);
INSERT INTO customers (id, discount) VALUES (1002, 5.00);
INSERT INTO customers (id, discount) VALUES (1003, 10.00);

-- WAITERS
INSERT INTO waiters (id, salary) VALUES (2001, 2500.00);
INSERT INTO waiters (id, salary) VALUES (2002, 2300.00);

-- SUPPLIERS
INSERT INTO suppliers (id, term) VALUES (3001, 'Paypal');
INSERT INTO suppliers (id, term) VALUES (3002, 'Bank Transfer');

-- CATEGORIES
INSERT INTO categories (id, name) VALUES (1, 'Main Course');
INSERT INTO categories (id, name) VALUES (2, 'Appetizer');
INSERT INTO categories (id, name) VALUES (3, 'Dessert');

-- DISHES
INSERT INTO dishes (id, name, description, price, category_id) VALUES (10, 'Spaghetti Carbonara', 'Pasta with bacon and eggs', 12.50, 1);
INSERT INTO dishes (id, name, description, price, category_id) VALUES (11, 'Caesar Salad', 'Salad with chicken and croutons', 8.00, 2);
INSERT INTO dishes (id, name, description, price, category_id) VALUES (12, 'Tiramisu', 'Coffee-flavored Italian dessert', 6.50, 3);
INSERT INTO dishes (id, name, description, price, category_id) VALUES (13, 'Ukrainian Borscht', 'Beet soup with sour cream', 10.00, 1);

-- INGREDIENTS
INSERT INTO ingredients (id, name, unit, quantity) VALUES (201, 'Pasta', 'kg', 5);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (202, 'Bacon', 'kg', 3);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (203, 'Eggs', 'pcs', 30);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (204, 'Carrot', 'kg', 10);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (205, 'Beetroot', 'kg', 8);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (206, 'Cream', 'l', 4);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (207, 'Chicken', 'kg', 6);
INSERT INTO ingredients (id, name, unit, quantity) VALUES (208, 'Lettuce', 'kg', 2);

-- DISH_INGREDIENTS
INSERT INTO dish_ingredients VALUES (10, 201, 0.1); -- Pasta
INSERT INTO dish_ingredients VALUES (10, 202, 0.05); -- Bacon
INSERT INTO dish_ingredients VALUES (10, 203, 2); -- Eggs
INSERT INTO dish_ingredients VALUES (11, 207, 0.1); -- Chicken
INSERT INTO dish_ingredients VALUES (11, 208, 0.05); -- Lettuce
INSERT INTO dish_ingredients VALUES (13, 204, 0.1); -- Carrot
INSERT INTO dish_ingredients VALUES (13, 205, 0.1); -- Beetroot
INSERT INTO dish_ingredients VALUES (13, 206, 0.05); -- Cream

-- DELIVERIES
INSERT INTO deliveries (id, supplier_id, delivered_on) VALUES (4001, 3001, SYSDATE - 5);
INSERT INTO deliveries (id, supplier_id, delivered_on) VALUES (4002, 3002, SYSDATE - 2);

-- DELIVERED
INSERT INTO delivered VALUES (201, 4001, 10, 1.2);
INSERT INTO delivered VALUES (202, 4001, 5, 4.0);
INSERT INTO delivered VALUES (203, 4001, 60, 0.2);
INSERT INTO delivered VALUES (205, 4002, 8, 0.8);
INSERT INTO delivered VALUES (204, 4002, 6, 0.6);

-- TABLES
INSERT INTO tables (id, capacity) VALUES (1, 2);
INSERT INTO tables (id, capacity) VALUES (2, 4);
INSERT INTO tables (id, capacity) VALUES (3, 6);

-- ORDERS
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips) VALUES (5001, 1001, 2001, SYSDATE - 1, 3.50);
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips) VALUES (5002, 1002, 2002, SYSDATE - 2, 5.00);
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips) VALUES (5003, 1003, 2001, SYSDATE, 0.00);
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips)
VALUES (5004, 1001, 2001, SYSDATE - 2 + INTERVAL '11:00' HOUR TO MINUTE, 4.00);
INSERT INTO dishes_to_orders VALUES (5004, 11, 1);
INSERT INTO service (order_id, table_id, status, served_on)
VALUES (5004, 1, 'Served', SYSDATE - 2 + INTERVAL '11:30' HOUR TO MINUTE);
-- Заказ 5005: 1 час разницы
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips)
VALUES (5005, 1002, 2002, SYSDATE - 1 + INTERVAL '13:15' HOUR TO MINUTE, 5.00);
INSERT INTO dishes_to_orders VALUES (5005, 12, 1);
INSERT INTO service (order_id, table_id, status, served_on)
VALUES (5005, 2, 'Served', SYSDATE - 1 + INTERVAL '14:15' HOUR TO MINUTE);
-- Заказ 5006: 10 минут разницы
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips)
VALUES (5006, 1003, 2001, SYSDATE - 1 + INTERVAL '18:00' HOUR TO MINUTE, 2.00);
INSERT INTO dishes_to_orders VALUES (5006, 13, 2);
INSERT INTO service (order_id, table_id, status, served_on)
VALUES (5006, 3, 'Served', SYSDATE - 1 + INTERVAL '18:10' HOUR TO MINUTE);
-- Заказ 5007: 2 часа 15 минут разницы
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips)
VALUES (5007, 1002, 2002, SYSDATE - 3 + INTERVAL '10:00' HOUR TO MINUTE, 3.00);
INSERT INTO dishes_to_orders VALUES (5007, 10, 1);
INSERT INTO service (order_id, table_id, status, served_on)
VALUES (5007, 2, 'Served', SYSDATE - 3 + INTERVAL '12:15' HOUR TO MINUTE);
-- Заказ 5008: 45 минут разницы
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips)
VALUES (5008, 1003, 2001, SYSDATE - 4 + INTERVAL '19:00' HOUR TO MINUTE, 6.00);

INSERT INTO dishes_to_orders VALUES (5008, 13, 1);

INSERT INTO service (order_id, table_id, status, served_on)
VALUES (5008, 1, 'Served', SYSDATE - 4 + INTERVAL '19:45' HOUR TO MINUTE);

-- DISHES_TO_ORDERS
INSERT INTO dishes_to_orders VALUES (5001, 10, 2);
INSERT INTO dishes_to_orders VALUES (5001, 12, 1);
INSERT INTO dishes_to_orders VALUES (5002, 11, 1);
INSERT INTO dishes_to_orders VALUES (5002, 13, 1);
INSERT INTO dishes_to_orders VALUES (5003, 10, 1);
INSERT INTO dishes_to_orders VALUES (5003, 13, 2);

-- SERVICE
INSERT INTO service (order_id, table_id, status, served_on) VALUES (5001, 2, 'Served', SYSDATE - 1);
INSERT INTO service (order_id, table_id, status, served_on) VALUES (5002, 3, 'Pending', NULL);
INSERT INTO service (order_id, table_id, status, served_on) VALUES (5003, 1, 'Pending', NULL);

-- REVIEWS
INSERT INTO reviews VALUES (1001, SYSDATE - 1, 5, 'Excellent service and delicious food!');
INSERT INTO reviews VALUES (1002, SYSDATE - 2, 4, 'Nice food, a bit slow service.');
INSERT INTO reviews VALUES (1003, SYSDATE, 3, 'Average experience.');
COMMIT;