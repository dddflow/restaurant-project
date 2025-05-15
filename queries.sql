-- All dishes with the corresponding category and name
SELECT d.name AS dish_name, c.name AS category, d.price
FROM dishes d
JOIN categories c ON d.category_id = c.id;

-- List of the customers
SELECT p.name, c.discount
FROM customers c
JOIN people p ON c.id = p.id;

-- Orders
SELECT id AS order_id, made_on, tips
FROM orders;

-- Waiters and their salary
SELECT p.name, w.salary
FROM waiters w
JOIN people p ON w.id = p.id;

-- Среднее между заказом и подачей (надо проверить)
SELECT ROUND(AVG((s.served_on - o.made_on) * 24 * 60), 2) AS avg_minutes_to_serve
FROM service s
JOIN orders o ON s.order_id = o.id
WHERE s.served_on IS NOT NULL;

-- Тут я проверяю триггер который вычитает ингридиенты при заказе:
-- Было 14.60 ингридиента пасты
SELECT id, name, quantity
FROM ingredients
WHERE id = 201;

-- Она используется в блюде Карбонара
SELECT *
FROM dish_ingredients
WHERE dish_id = 10;

-- Добавляем заказ
INSERT INTO orders (id, customer_id, waiter_id, made_on, tips)
VALUES (6001, 1001, 2001, SYSDATE, 2.00);


-- Добавляем 2 карбонары в заказ
INSERT INTO dishes_to_orders (order_id, dish_id, quantity)
VALUES (6001, 10, 2);

-- В карбонаре используется 0.1 пасты, значит должно списаться 0.2 из таблицы ингридиентов
SELECT id, name, quantity
FROM ingredients
WHERE id = 201;

-- действительно становиться 14.40