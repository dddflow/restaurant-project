CREATE TABLE PEOPLE (
    id      NUMBER,
    name    VARCHAR2(100),
    gender  CHAR(1),
    email   VARCHAR2(100),
    phone   VARCHAR2(20),

    CONSTRAINT pk_people PRIMARY KEY (id),
    CONSTRAINT uq_people_email UNIQUE (email),
    CONSTRAINT uq_people_phone UNIQUE (phone),
    CONSTRAINT chk_people_gender CHECK (gender IN ('M', 'F'))
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
    CONSTRAINT fk_service_tables FOREIGN KEY (table_id) REFERENCES TABLES(id),
    CHECK (status IN ('Pending', 'Served', 'Cancelled'))
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

CREATE TABLE DISH_INGREDIENTS (
    dish_id         NUMBER,
    ingredient_id   NUMBER,
    quantity_needed NUMBER(10,2),

    CONSTRAINT pk_dish_ingredients PRIMARY KEY (dish_id, ingredient_id),
    CONSTRAINT fk_di_dish FOREIGN KEY (dish_id) REFERENCES DISHES(id),
    CONSTRAINT fk_di_ingredient FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(id),
    CONSTRAINT chk_quantity_positive CHECK (quantity_needed > 0)
);

-- Insert a new person
insert into people (id, name, gender, email, phone)
values (1001, 'Alice Cust', 'F', 'alice.cust@gmail.com', '9999999');

insert into people (id, name, gender, email, phone)
values (2001, 'Bob Waiter', 'M', 'bob.waiter@gmail.com', '8888888');

insert into people (id, name, gender, email, phone)
values (3001, 'Vova Sup', 'M', 'vova.sup@gmail.com', '7777777');

-- Insert a new customer
insert into customers (id, discount)
values (1001, 15.00);

-- Insert a new waiter
insert into waiters (id, salary)
values (2001, 2500.00);

-- Insert a new suppliers
insert into suppliers (id, term)
values (3001, 'Paypal');

-- Insert a new category
insert into categories (id, name)
values (1, 'Main Course');

-- Insert a new dish
insert into dishes (id, name, description, price, category_id)
values (10, 'Spaghetti Carbonara', 'Pasta with bacon and eggs', 12.50, 1);

-- Insert a new ingredients
insert into ingredients (id, name, unit, quantity)
values (204, 'Carrot', 'kg', 0);

-- Insert a new deliveries
insert into deliveries (id, supplier_id, delivered_on)
values (4011, 3001, sysdate);

insert into delivered (ingredient_id, delivery_id, unit_number, unit_price)
values (204, 4011, 20, 1.05);

-- Insert a new table
insert into tables (id, capacity)
values (5, 4);

-- Insert the order
insert into orders (id, customer_id, waiter_id, made_on, tips)
values (5001, 1001, 2001, sysdate, 3.50);

-- Link the dish to the order
insert into dishes_to_orders (order_id, dish_id, quantity)
values (5001, 10, 2);

-- Assign the order to the table
insert into service (order_id, table_id, status, served_on)
values (5001, 5, 'Pending', null);

-- Insert a review
insert into reviews (id, reviewed_on, rating, review)
values (1001, sysdate, 5, 'Excellent service and delicious food!');

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
COMMIT;

-- Нужно как будто сделать триггер который будет при добавлении блюда в заказ автоматически вычитать ингридиенты