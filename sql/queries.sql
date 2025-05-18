-- All dishes with the corresponding category and name
SELECT
    D.DISH_NAME AS dish_name,
    C.CATEGORY_NAME AS category,
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
    ID AS order_id,
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
SELECT ROUND(AVG((S.SERVED_ON - O.MADE_ON) * 24 * 60), 2) AS avg_minutes_to_serve
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

-- Она используется в блюде Карбонара
SELECT
    DISH_ID,
    INGREDIENT_ID,
    QUANTITY_NEEDED
FROM DISH_INGREDIENTS
WHERE DISH_ID = 10;

-- В карбонаре используется 0.1 пасты, значит должно списаться 0.2 из таблицы ингридиентов
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