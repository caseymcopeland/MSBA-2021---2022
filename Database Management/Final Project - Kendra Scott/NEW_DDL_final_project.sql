-- Drop Sequence/Tables --
--------------------------
DROP TABLE shipping_linking; -- drop linking tables
DROP TABLE product_order_linking; 
DROP SEQUENCE customer_id_seq; -- drop sequences 
DROP SEQUENCE courier_id_seq;
DROP SEQUENCE product_id_seq;
DROP SEQUENCE credit_card_id_seq;
DROP SEQUENCE order_id_seq;
DROP SEQUENCE member_credit_card_id_seq;
DROP SEQUENCE member_order_id_seq;
DROP SEQUENCE member_id_seq;
DROP SEQUENCE warehouse_id_seq;
DROP TABLE member_credit_cards;
DROP TABLE member_orders;
DROP TABLE members;
DROP TABLE orders;
DROP TABLE warehouses;
DROP TABLE credit_cards;
DROP TABLE couriers;
DROP TABLE orders;
DROP TABLE customers;
DROP TABLE inventory_products;
------------------------------------
-- Create Sequence/Tables Section --
-- Create all the tables without foreign keys first --
------------------------------------

-- Customers
CREATE TABLE customers
(
  customer_id         NUMBER        NOT NULL, --primary key
  first_name          VARCHAR(50)   NOT NULL,
  last_name           VARCHAR(50)   NOT NULL,
  birthdate           DATE                  ,           -- Says this field can be null
  email               VARCHAR(50)   UNIQUE  ,
  phone               CHAR(12)      NOT NULL,
  address_line_1      VARCHAR(50)   NOT NULL,
  address_line_2      VARCHAR(50)           , -- Says this field can be null
  city                VARCHAR(50)   NOT NULL,
  state               VARCHAR(2)    NOT NULL,
  zip_code            CHAR(5)       NOT NULL,
  
  CONSTRAINT customer_pk     PRIMARY KEY (customer_id) 
);

CREATE SEQUENCE customer_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
-- Couriers
CREATE TABLE couriers
(
  courier_id        NUMBER        NOT NULL,
  courier_name      VARCHAR(50)   NOT NULL,
  tracking_number   VARCHAR(50)   UNIQUE NOT NULL,
  
  CONSTRAINT courier_pk     PRIMARY KEY (courier_id)
);
CREATE SEQUENCE courier_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
   
--Inventory_Products
CREATE TABLE inventory_products
(
  product_id        NUMBER        NOT NULL,
  unit_price        CHAR(10)      NOT NULL,
  quanity_on_hand   NUMBER        NOT NULL,
  quanity_available NUMBER        NOT NULL,
  production_time   NUMBER        NOT NULL,
  
  CONSTRAINT inventory_products_pk   PRIMARY KEY (product_id)
);
CREATE SEQUENCE product_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
-- Credit_Card
CREATE TABLE credit_cards
(
  card_id           NUMBER        NOT NULL,
  customer_id       NUMBER        NOT NULL,
  first_name        VARCHAR(50)   NOT NULL,
  middle_name       VARCHAR(50)           , --can be null
  last_name         VARCHAR(50)   NOT NULL,
  card_type         CHAR(4)       NOT NULL,
  card_number       NUMBER        NOT NULL,
  exp_date          DATE          NOT NULL,
  security_code     NUMBER        NOT NULL,
  zip_code          CHAR(5)       NOT NULL,
  
  CONSTRAINT credit_card_pk       PRIMARY KEY(card_id),
  CONSTRAINT credit_cards_fk FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);
CREATE SEQUENCE credit_card_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
------------------------------------
-- Create Sequence/Tables Section --
-- Create all the tables with foreign keys first --
------------------------------------

--Online Order Processing Tables
CREATE TABLE orders
(
  order_id          NUMBER        NOT NULL,
  customer_id       NUMBER        NOT NULL,
  order_date        DATE          NOT NULL,
  product_id        NUMBER        NOT NULL,
  total_price       CHAR(10)      NOT NULL,
  order_details     VARCHAR(1000)         ,
  
  CONSTRAINT orders_pk   PRIMARY KEY (order_id), 
  CONSTRAINT orders_fk   FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
  CONSTRAINT orders_fk_2 FOREIGN KEY (product_id) REFERENCES inventory_products (product_id)
);
CREATE SEQUENCE order_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
-- Shipping (linking table)
CREATE TABLE shipping_linking
(
  order_id               NUMBER        NOT NULL,
  courier_id             NUMBER        NOT NULL,
  shipping_date          DATE          NOT NULL,
  ship_address_line_1    VARCHAR(50)   NOT NULL,
  ship_address_line_2    VARCHAR(50)           ,
  ship_city              VARCHAR(50)   NOT NULL,
  ship_state             VARCHAR(2)    NOT NULL,
  ship_zipcode           CHAR(5)       NOT NULL,
  
  CONSTRAINT shipping_PK     PRIMARY KEY (order_id, courier_id),
  CONSTRAINT shipping_FK     FOREIGN KEY (order_id)   REFERENCES Orders (order_id),
  CONSTRAINT shipping_FK_2   FOREIGN KEY (courier_id) REFERENCES Couriers (courier_id)
  
);

 
-- Product Order (linking table)

CREATE TABLE product_order_linking
(
  order_id        NUMBER        NOT NULL,
  Product_id      NUMBER        NOT NULL,
  product_name    VARCHAR(300)   NOT NULL,
  department_name VARCHAR(50)           ,
  unit_price      CHAR(10)      NOT NULL,
  quantity        NUMBER        NOT NULL,
  
  CONSTRAINT product_order_pk     PRIMARY KEY (order_id, product_id),
  CONSTRAINT product_order_fk     FOREIGN KEY (order_id)   REFERENCES orders (order_id),
  CONSTRAINT product_order_fk_2   FOREIGN KEY (product_id) REFERENCES inventory_products (product_id)
  
);

CREATE TABLE member_credit_cards
(
  card_id           NUMBER        NOT NULL,
  first_name        VARCHAR(50)   NOT NULL,
  middle_name       VARCHAR(50)           , --can be null
  last_name         VARCHAR(50)   NOT NULL,
  card_type         CHAR(4)       NOT NULL,
  card_number       NUMBER        NOT NULL,
  exp_date          DATE          NOT NULL,
  security_code     NUMBER        NOT NULL,
  zip_code          CHAR(5)       NOT NULL,
  
  CONSTRAINT member_credit_card_pk         PRIMARY KEY(card_id)
);

CREATE SEQUENCE member_credit_card_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;

    
CREATE TABLE members
(
 member_id              NUMBER        NOT NULL,
 customer_id            NUMBER        NOT NULL,
 email                  VARCHAR(100)  NOT NULL,
 member_start_date      DATE          NOT NULL,
 home_store             VARCHAR(100)  NOT NULL,
 home_state             VARCHAR(2)    NOT NULL,
 
 CONSTRAINT members_pk   PRIMARY KEY (member_id),
 CONSTRAINT members_fk   FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE SEQUENCE member_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
 
    
CREATE TABLE member_orders
(
  member_order_id          NUMBER        NOT NULL,
  member_id                NUMBER        NOT NULL,
  product_id               NUMBER        NOT NULL,
  member_order_date        DATE          NOT NULL,
  member_order_total       CHAR(10)      NOT NULL,
  member_order_details     VARCHAR(1000)         ,
  
  CONSTRAINT member_order_id_pk  PRIMARY KEY (member_order_id), 
  CONSTRAINT member_id_fk   FOREIGN KEY (member_id) REFERENCES members (member_id),
  CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES inventory_products (product_id)
);
CREATE SEQUENCE member_order_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
    
    
CREATE TABLE warehouses
(
  warehouse_id         NUMBER        NOT NULL,
  product_id           NUMBER        NOT NULL,
  warehouse_address    VARCHAR(50)   NOT NULL,
  warehouse_city       VARCHAR(50)   NOT NULL,
  warehouse_region     VARCHAR(50)   NOT NULL,
  warehouse_state      VARCHAR(2)    NOT NULL,
  
  CONSTRAINT warehouses_pk PRIMARY KEY (warehouse_id),
  CONSTRAINT warehouses_fk FOREIGN KEY (product_id) REFERENCES inventory_products (product_id)
);

CREATE SEQUENCE warehouse_id_seq -- sequence
    START WITH 1 INCREMENT BY 1;
