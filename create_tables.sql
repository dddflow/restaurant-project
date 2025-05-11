CREATE TABLE PEOPLE (
    id      NUMBER,
    name    VARCHAR2(100),
    gender  CHAR(1),
    email   VARCHAR2(100),
    phone   VARCHAR2(20),

    CONSTRAINT pk_people PRIMARY KEY (id)
);


CREATE TABLE SUPPLIERS (
    id      NUMBER,
    term    VARCHAR2(300),

    CONSTRAINT pk_suppliers PRIMARY KEY (id),
    CONSTRAINT fk_suppliers_people FOREIGN KEY (id) REFERENCES PEOPLE(id)
);


CREATE TABLE WAITERS (
    id      NUMBER,
    salary  NUMBER(10,2),

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
    reviewed_on DATE,
    rating      NUMBER(1),
    review      VARCHAR2(255),

    CONSTRAINT pk_reviews PRIMARY KEY (id, reviewed_on),
    CONSTRAINT fk_reviews_customers FOREIGN KEY (id) REFERENCES CUSTOMERS(id),
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
);


CREATE TABLE INGREDIENTS (
    id          NUMBER,
    name        VARCHAR2(100),
    unit        VARCHAR2(20),
    quantity    NUMBER(10,2),

    CONSTRAINT pk_ingredients PRIMARY KEY (id),
    CONSTRAINT chk_ingredients_quantity_nonnegative CHECK (quantity >= 0)
);


CREATE TABLE DELIVERIES (
    id              NUMBER,
    supplier_id     NUMBER,
    delivered_on    DATE,

    CONSTRAINT pk_deliveries PRIMARY KEY (id),
    CONSTRAINT fk_deliveries_suppliers FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(id)
);


CREATE TABLE DELIVERED (
    ingredient_id   NUMBER,
    delivery_id     NUMBER,
    unit_number     NUMBER(10,2),
    unit_price      NUMBER(10,2),

    CONSTRAINT pk_delivered PRIMARY KEY (ingredient_id, delivery_id),
    CONSTRAINT fk_delivered_ingredients FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(id),
    CONSTRAINT fk_delivered_deliveries FOREIGN KEY (delivery_id) REFERENCES DELIVERIES(id),
    CONSTRAINT chk_delivered_price_nonnegative CHECK (unit_price >= 0),
    CONSTRAINT chk_delivered_units_nonnegative CHECK (unit_number >= 0)
);


CREATE TABLE ORDERS (
    id          NUMBER,
    customer_id NUMBER,
    waiter_id   NUMBER,
    made_on     DATE,
    tips        NUMBER(10,2),

    CONSTRAINT pk_orders PRIMARY KEY (id),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(id),
    CONSTRAINT fk_orders_waiters FOREIGN KEY (waiter_id) REFERENCES WAITERS(id),
    CONSTRAINT chk_orders_tips_nonnegative CHECK (tips >= 0)
);


CREATE TABLE TABLES (
    id          NUMBER,
    capacity    NUMBER,

    CONSTRAINT pk_tables PRIMARY KEY (id),
    CONSTRAINT chk_tables_capacity_positive CHECK (capacity > 0)
);


CREATE TABLE SERVICE (
    order_id    NUMBER,
    table_id    NUMBER,
    status      VARCHAR2(50),
    served_on   DATE,

    CONSTRAINT pk_service PRIMARY KEY (order_id, table_id),
    CONSTRAINT fk_service_orders FOREIGN KEY (order_id) REFERENCES ORDERS(id),
    CONSTRAINT fk_service_tables FOREIGN KEY (table_id) REFERENCES TABLES(id)
);


create table CATEGORIES (
    id      NUMBER,
    name    VARCHAR2(100),

    CONSTRAINT pk_categories PRIMARY KEY (id)
);


CREATE TABLE DISHES (
    id          NUMBER,
    name        VARCHAR2(100),
    description VARCHAR2(500),
    price       NUMBER(6,2),
    category_id NUMBER,

    CONSTRAINT pk_dishes PRIMARY KEY (id),
    CONSTRAINT fk_dishes_category FOREIGN KEY (category_id) REFERENCES CATEGORIES(id),
    CONSTRAINT chk_dishes_price_positive CHECK (price >= 0)
);


CREATE TABLE DISHES_TO_ORDERS (
    order_id    NUMBER,
    dish_id     NUMBER,
    quantity    NUMBER,

    CONSTRAINT pk_dto PRIMARY KEY (order_id, dish_id),
    CONSTRAINT fk_dto_orders FOREIGN KEY (order_id) REFERENCES ORDERS(id),
    CONSTRAINT fk_dto_dishes FOREIGN KEY (dish_id) REFERENCES DISHES(id)
);
