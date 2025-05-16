CREATE TABLE PEOPLE (
    id     NUMBER,
    name   VARCHAR2(100) NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F')),
    email  VARCHAR2(100) NOT NULL,
    phone  VARCHAR2(20)  NOT NULL,
    CONSTRAINT pk_people PRIMARY KEY (id),
    CONSTRAINT uq_people_email UNIQUE (email),
    CONSTRAINT uq_people_phone UNIQUE (phone)
);


CREATE TABLE SUPPLIERS (
    id      NUMBER,
    term    VARCHAR2(300),

    CONSTRAINT pk_suppliers PRIMARY KEY (id),
    CONSTRAINT fk_suppliers_people FOREIGN KEY (id) REFERENCES PEOPLE(id)
);


CREATE TABLE WAITERS (
    id      NUMBER,
    salary  NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_waiters PRIMARY KEY (id),
    CONSTRAINT fk_waiters_people FOREIGN KEY (id) REFERENCES PEOPLE(id)
);


CREATE TABLE CUSTOMERS (
    id          NUMBER,
    discount    NUMBER(5,2),

    CONSTRAINT pk_customers PRIMARY KEY (id),
    CONSTRAINT fk_customers_people FOREIGN KEY (id) REFERENCES PEOPLE(id)
);


CREATE TABLE REVIEWS (
   id          NUMBER,
   reviewed_on DATE NOT NULL,
   rating      NUMBER(1) NOT NULL,
    review      VARCHAR2(255),

    CONSTRAINT pk_reviews PRIMARY KEY (id, reviewed_on),
    CONSTRAINT fk_reviews_customers FOREIGN KEY (id) REFERENCES CUSTOMERS(id),
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
);


CREATE TABLE INGREDIENTS (
    id          NUMBER,
    name        VARCHAR2(100) NOT NULL,
    unit        VARCHAR2(20) NOT NULL,
    quantity    NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_ingredients PRIMARY KEY (id),
    CONSTRAINT chk_ingredients_quantity_nonnegative CHECK (quantity >= 0)
);


CREATE TABLE DELIVERIES (
    id              NUMBER,
    supplier_id     NUMBER NOT NULL,
    delivered_on    DATE NOT NULL,

    CONSTRAINT pk_deliveries PRIMARY KEY (id),
    CONSTRAINT fk_deliveries_suppliers FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(id)
);


CREATE TABLE DELIVERED (
    ingredient_id   NUMBER NOT NULL,
    delivery_id     NUMBER NOT NULL,
    unit_number     NUMBER(10,2) NOT NULL,
    unit_price      NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_delivered PRIMARY KEY (ingredient_id, delivery_id),
    CONSTRAINT fk_delivered_ingredients FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(id),
    CONSTRAINT fk_delivered_deliveries FOREIGN KEY (delivery_id) REFERENCES DELIVERIES(id),
    CONSTRAINT chk_delivered_price_nonnegative CHECK (unit_price >= 0),
    CONSTRAINT chk_delivered_units_nonnegative CHECK (unit_number >= 0)
);


CREATE TABLE ORDERS (
    id          NUMBER,
    customer_id NUMBER NOT NULL,
    waiter_id   NUMBER NOT NULL,
    made_on     DATE NOT NULL,
    tips        NUMBER(10,2),

    CONSTRAINT pk_orders PRIMARY KEY (id),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(id),
    CONSTRAINT fk_orders_waiters FOREIGN KEY (waiter_id) REFERENCES WAITERS(id),
    CONSTRAINT chk_orders_tips_nonnegative CHECK (tips >= 0)
);


CREATE TABLE TABLES (
    id          NUMBER,
    capacity    NUMBER NOT NULL,

    CONSTRAINT pk_tables PRIMARY KEY (id),
    CONSTRAINT chk_tables_capacity_positive CHECK (capacity > 0)
);


CREATE TABLE SERVICE (
    order_id    NUMBER NOT NULL,
    table_id    NUMBER NOT NULL,
    status      VARCHAR2(50) NOT NULL,
    served_on   DATE NOT NULL,

    CONSTRAINT pk_service PRIMARY KEY (order_id, table_id),
    CONSTRAINT fk_service_orders FOREIGN KEY (order_id) REFERENCES ORDERS(id),
    CONSTRAINT fk_service_tables FOREIGN KEY (table_id) REFERENCES TABLES(id),
    CHECK (status IN ('Pending', 'Served', 'Cancelled'))
);


create table CATEGORIES (
    id      NUMBER,
    name    VARCHAR2(100) NOT NULL,

    CONSTRAINT pk_categories PRIMARY KEY (id)
);


CREATE TABLE DISHES (
    id          NUMBER,
    name        VARCHAR2(100) NOT NULL,
    description VARCHAR2(500) NOT NULL,
    price       NUMBER(6,2) NOT NULL,
    category_id NUMBER NOT NULL,

    CONSTRAINT pk_dishes PRIMARY KEY (id),
    CONSTRAINT fk_dishes_category FOREIGN KEY (category_id) REFERENCES CATEGORIES(id),
    CONSTRAINT chk_dishes_price_positive CHECK (price >= 0)
);


CREATE TABLE DISHES_TO_ORDERS (
    order_id    NUMBER NOT NULL,
    dish_id     NUMBER NOT NULL,
    quantity    NUMBER NOT NULL,

    CONSTRAINT pk_dto PRIMARY KEY (order_id, dish_id),
    CONSTRAINT fk_dto_orders FOREIGN KEY (order_id) REFERENCES ORDERS(id),
    CONSTRAINT fk_dto_dishes FOREIGN KEY (dish_id) REFERENCES DISHES(id)
);

CREATE TABLE DISH_INGREDIENTS (
    dish_id         NUMBER NOT NULL,
    ingredient_id   NUMBER NOT NULL,
    quantity_needed NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_dish_ingredients PRIMARY KEY (dish_id, ingredient_id),
    CONSTRAINT fk_di_dish FOREIGN KEY (dish_id) REFERENCES DISHES(id),
    CONSTRAINT fk_di_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(id),
    CONSTRAINT chk_quantity_positive CHECK (quantity_needed > 0)
);



-- Trigger for updating quantity of ingredients after delivery
CREATE OR REPLACE TRIGGER trg_update_ingredient_quantity
    AFTER INSERT ON delivered
    FOR EACH ROW
BEGIN
    UPDATE ingredients
    SET quantity = quantity + :NEW.unit_number
    WHERE id = :NEW.ingredient_id;
END;
/

-- Добавить ошибку (либо остановиться на constraint quantity > 0)
CREATE OR REPLACE TRIGGER trg_subtract_ingredients_on_order
AFTER INSERT ON DISHES_TO_ORDERS
FOR EACH ROW
BEGIN
    FOR rec IN (
        SELECT ingredient_id, quantity_needed
        FROM DISH_INGREDIENTS
        WHERE dish_id = :NEW.dish_id
    ) LOOP
        UPDATE INGREDIENTS
        SET quantity = quantity - (rec.quantity_needed * :NEW.quantity)
        WHERE id = rec.ingredient_id;
    END LOOP;
END;
/
COMMIT;

-- Нужно как будто сделать триггер который будет при добавлении блюда в заказ автоматически вычитать ингридиенты