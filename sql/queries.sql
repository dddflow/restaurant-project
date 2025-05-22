-- All dishes with the corresponding category and name
SELECT
    D.DISH_NAME,
    C.CATEGORY_NAME,
    D.PRICE
FROM DISHES D
INNER JOIN CATEGORIES C ON D.CATEGORY_ID = C.ID;

-- List of the customers
SELECT
    P.PERSON_NAME,
    C.DISCOUNT
FROM CUSTOMERS C
INNER JOIN PEOPLE P ON C.ID = P.ID;

-- Orders
SELECT
    ID,
    MADE_ON,
    TIPS
FROM RESTAURANT_ORDERS;

-- Waiters and their salary
SELECT
    P.PERSON_NAME,
    W.SALARY
FROM WAITERS W
INNER JOIN PEOPLE P ON W.ID = P.ID;

-- Среднее между заказом и подачей (надо проверить)
SELECT ROUND(AVG((S.SERVED_ON - O.MADE_ON) * 24 * 60), 2) AS "avg_minutes_to_serve"
FROM TABLE_SERVICE S
INNER JOIN RESTAURANT_ORDERS O ON S.ORDER_ID = O.ID
WHERE S.SERVED_ON IS NOT NULL;

-- Тут я проверяю триггер который вычитает ингридиенты при заказе:
-- Было 14.60 ингридиента пасты
SELECT
    ID,
    INGREDIENT_NAME,
    QUANTITY
FROM INGREDIENTS
WHERE ID = 201;

--проверяю новый триггер trg_check_ingredient_stock
INSERT INTO RESTAURANT_ORDERS (ID, CUSTOMER_ID, WAITER_ID, MADE_ON, TIPS)
VALUES (6003, 1001, 2001, SYSDATE, 2.00);

-- Добавляем 25 карбонары в заказ
INSERT INTO DISHES_TO_ORDERS (ORDER_ID, DISH_ID, QUANTITY)
VALUES (6003, 10, 25);

-- теперь карбонары 12.10
SELECT
    ID,
    INGREDIENT_NAME,
    QUANTITY
FROM INGREDIENTS
WHERE ID = 201;

-- SQL QUERIES FOR THE REPORT

--Shows the 5 most popular dishes in terms of quantity ordered.
SELECT d.dish_name, SUM(dto.quantity) AS total_ordered
FROM dishes_to_orders dto
JOIN dishes d ON dto.dish_id = d.id
GROUP BY d.dish_name
ORDER BY total_ordered DESC
FETCH FIRST 5 ROWS ONLY;

-- Ranks all waiters by the total amount of tips they have received.
SELECT p.person_name AS waiter_name, SUM(ro.tips) AS total_tips
FROM restaurant_orders ro
JOIN waiters w ON ro.waiter_id = w.id
JOIN people p ON w.id = p.id
GROUP BY p.person_name
ORDER BY total_tips DESC;

-- Calculates the average number of minutes it takes to serve an order.
SELECT ROUND(AVG((s.served_on - ro.made_on) * 24 * 60), 2) AS avg_minutes
FROM table_service s
JOIN restaurant_orders ro ON s.order_id = ro.id
WHERE s.served_on IS NOT NULL;

-- Надо добавить еще 2 запроса использующие операции с множествами!