-- Drop Sequence/Tables --
--------------------------
DROP TABLE Shipping_Linking; -- drop linking tables
DROP TABLE Product_Order_Linking; 
DROP SEQUENCE customer_ID_seq; -- drop sequences 
DROP SEQUENCE courier_ID_seq;
DROP SEQUENCE product_ID_seq;
DROP SEQUENCE credit_card_ID_seq;
DROP SEQUENCE Order_ID_seq;
DROP SEQUENCE member_credit_card_ID_seq;
DROP SEQUENCE order_history_ID_seq;
DROP SEQUENCE member_ID_seq;
DROP SEQUENCE warehouse_ID_seq;
DROP TABLE Members;
DROP TABLE Member_order_history;
DROP TABLE Orders;
DROP TABLE Warehouses;
DROP TABLE credit_cards;
DROP TABLE member_credit_cards;
DROP TABLE Customers;
DROP TABLE Couriers;
DROP TABLE Inventory_Products;

------------------------------------
-- Create Sequence/Tables Section --
-- Create all the tables without foreign keys first --
------------------------------------

-- Customers
CREATE TABLE Customers
(
  Customer_ID         NUMBER        NOT NULL, --primary key
  First_name          VARCHAR(50)   NOT NULL,
  Last_name           VARCHAR(50)   NOT NULL,
  Birthdate           DATE,           -- Says this field can be null
  Email               VARCHAR(50)   UNIQUE,
  Phone               CHAR(12)      NOT NULL,
  Address_Line_1      VARCHAR(50)   NOT NULL,
  Address_Line_2      VARCHAR(50)    , -- Says this field can be null
  City                VARCHAR(50)   NOT NULL,
  State_              CHAR(2)       NOT NULL,
  Zip_code            CHAR(5)       NOT NULL,
  
  CONSTRAINT Customer_pk     PRIMARY KEY (Customer_ID) 
);

CREATE SEQUENCE customer_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
-- Couriers
CREATE TABLE Couriers
(
  Courier_ID        NUMBER        NOT NULL,
  courier_name      VARCHAR(50)   NOT NULL,
  tracking_number   NUMBER        NOT NULL,
  
  CONSTRAINT Courier_PK     PRIMARY KEY (Courier_ID)
);
CREATE SEQUENCE courier_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
   
--Inventory_Products
CREATE TABLE Inventory_Products
(
  product_ID        NUMBER        NOT NULL,
  unit_price        NUMBER        NOT NULL,
  quanity_on_hand   NUMBER        NOT NULL,
  quanity_available NUMBER        NOT NULL,
  production_time   NUMBER        NOT NULL,
  
  CONSTRAINT Inventory_Products_PK     PRIMARY KEY (product_ID)
);
CREATE SEQUENCE product_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
-- Credit_Card
CREATE TABLE Credit_Cards
(
  card_ID           NUMBER        NOT NULL,
  first_name        VARCHAR(50)   NOT NULL,
  middle_name       VARCHAR(50)  , --can be null
  last_name         VARCHAR(50)   NOT NULL,
  card_type         CHAR(4)       NOT NULL,
  card_number       NUMBER        NOT NULL,
  exp_date          NUMBER        NOT NULL,
  security_code     NUMBER        NOT NULL,
  zip_code          NUMBER        NOT NULL,
  
  CONSTRAINT Credit_Card_PK         PRIMARY KEY(card_ID)
);
CREATE SEQUENCE credit_card_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
------------------------------------
-- Create Sequence/Tables Section --
-- Create all the tables with foreign keys first --
------------------------------------

--Online Order Processing Tables
CREATE TABLE Orders
(
  Order_ID          NUMBER        NOT NULL,
  customer_ID       NUMBER        NOT NULL,
  order_date        DATE          NOT NULL,
  product_ID        NUMBER        NOT NULL,
  total_price       NUMBER        NOT NULL,
  order_details     VARCHAR(1000) NOT NULL,
  
  CONSTRAINT orders_PK   PRIMARY KEY (Order_ID), 
  CONSTRAINT orders_fk   FOREIGN KEY (Customer_ID) REFERENCES Customers (Customer_ID),
  CONSTRAINT orders_fk_2 FOREIGN KEY (product_ID) REFERENCES Inventory_Products (product_ID)
);
CREATE SEQUENCE Order_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
-- Shipping (linking table)
CREATE TABLE Shipping_Linking
(
  Order_ID        NUMBER        NOT NULL,
  courier_ID      NUMBER        NOT NULL,
  shipping_date   DATE          NOT NULL,
  ship_address    VARCHAR(50)   NOT NULL,
  ship_address_2  VARCHAR(50)   ,
  ship_city       VARCHAR(50)   NOT NULL,
  ship_region     VARCHAR(50)   NOT NULL,
  ship_zipcode    NUMBER        NOT NULL,
  
  CONSTRAINT shipping_PK     PRIMARY KEY (order_ID, courier_ID),
  CONSTRAINT shipping_FK     FOREIGN KEY (order_ID)   REFERENCES Orders (order_ID),
  CONSTRAINT shipping_FK_2   FOREIGN KEY (courier_ID) REFERENCES Couriers (courier_ID)
  
);

 
-- Product Order (linking table)

CREATE TABLE Product_Order_Linking
(
  Order_ID        NUMBER        NOT NULL,
  Product_ID      NUMBER        NOT NULL,
  product_name    VARCHAR(50)   NOT NULL,
  department_name VARCHAR(50)   NOT NULL,
  unit_price      NUMBER        NOT NULL,
  quantity        NUMBER        NOT NULL,
  
  CONSTRAINT Product_Order_PK     PRIMARY KEY (order_ID, product_ID),
  CONSTRAINT Product_Order_FK     FOREIGN KEY (order_ID)   REFERENCES Orders (order_ID),
  CONSTRAINT Product_Order_FK_2   FOREIGN KEY (product_ID) REFERENCES Inventory_Products (product_ID)
  
);

CREATE TABLE Member_Credit_Cards
(
  card_ID           NUMBER        NOT NULL,
  first_name        VARCHAR(50)   NOT NULL,
  middle_name       VARCHAR(50)  , --can be null
  last_name         VARCHAR(50)   NOT NULL,
  card_type         CHAR(4)       NOT NULL,
  card_number       NUMBER        NOT NULL,
  exp_date          NUMBER        NOT NULL,
  security_code     NUMBER        NOT NULL,
  zip_code          NUMBER        NOT NULL,
  
  CONSTRAINT Member_Credit_Card_PK         PRIMARY KEY(card_ID)
);

CREATE SEQUENCE member_credit_card_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;

CREATE TABLE Member_Order_History 
(
 order_history_ID     NUMBER        NOT NULL,
 order_ID             NUMBER        NOT NULL,
 total_orders         NUMBER        NOT NULL,
 total_spent          NUMBER        NOT NULL,
 
 CONSTRAINT order_history_pk        PRIMARY KEY (order_history_ID),
 CONSTRAINT order_history_fk FOREIGN KEY (order_ID) REFERENCES Orders (order_ID)
);

CREATE SEQUENCE order_history_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;

CREATE TABLE Members
(
 member_ID              NUMBER        NOT NULL,
 customer_ID            NUMBER        NOT NULL,
 card_ID                NUMBER        NOT NULL,
 email                  VARCHAR(100)  NOT NULL,
 member_start_date      DATE          NOT NULL,
 home_store             VARCHAR(50)   NOT NULL,
 home_state             VARCHAR(2)    NOT NULL,
 order_history_ID       NUMBER        NOT NULL,
 subscription_status    VARCHAR(100)  NOT NULL,
 
 CONSTRAINT members_PK   PRIMARY KEY (member_ID),
 CONSTRAINT members_FK   FOREIGN KEY (customer_ID)      REFERENCES Customers (Customer_ID),
 CONSTRAINT members_FK_2 FOREIGN KEY (card_ID)          REFERENCES Member_Credit_Cards (card_ID),
 CONSTRAINT members_FK_3 FOREIGN KEY (order_history_ID) REFERENCES Member_Order_History (order_history_ID)
);

CREATE SEQUENCE member_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
    
CREATE TABLE Warehouses
(
  warehouse_ID         NUMBER        NOT NULL,
  product_ID           NUMBER        NOT NULL,
  warehouse_address    VARCHAR(50)   NOT NULL,
  warehouse_city       VARCHAR(50)   NOT NULL,
  warehouse_region     VARCHAR(50)   NOT NULL,
  warehouse_state      VARCHAR(50)   NOT NULL,
  
  CONSTRAINT warehouses_PK PRIMARY KEY (warehouse_ID),
  CONSTRAINT warehouses_FK FOREIGN KEY (product_ID) REFERENCES Inventory_Products (product_ID)
);

CREATE SEQUENCE warehouse_ID_seq -- sequence
    START WITH 1 INCREMENT BY 1;
