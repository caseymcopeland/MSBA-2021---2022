-------
-- HW2 - DATABASE MANAGEMENT
-- GROUP NAMES: Rhiannon Pytlak, Casey Copeland, Sophia Scott, Ben Sullivan, Kolton Fowler
-- GROUP EIDS: rkp643,cmc6793, sbs2753, bws768, kjf937


--------------------------
-- Drop Sequence/Tables --
--------------------------
DROP TABLE Location_Features_Linking; -- drop linking tables
DROP TABLE Reservation_Details;
DROP INDEX room_location_id_ix; -- drop indexes
DROP INDEX reservation_customer_id_ix; 
DROP SEQUENCE room_id_seq; -- drop sequences 
DROP SEQUENCE feature_id_seq;
DROP SEQUENCE location_id_seq;
DROP SEQUENCE reservation_id_seq;
DROP SEQUENCE payment_id_seq;
DROP SEQUENCE customer_id_seq;
DROP TABLE Features;
DROP TABLE Customer_Payments;
DROP TABLE Rooms;
DROP TABLE Locations;
DROP TABLE Reservations;
DROP TABLE Customers;

------------------------------------
-- Create Sequence/Tables Section --
------------------------------------

-- Customers
CREATE TABLE Customers
(
  Customer_ID         NUMBER        NOT NULL, --primary key
  First_name          VARCHAR(50)   NOT NULL,
  Last_name           VARCHAR(50)   NOT NULL,
  Email               VARCHAR(50)   UNIQUE,
  Phone               CHAR(12)      NOT NULL,
  Address_Line_1      VARCHAR(50)   NOT NULL,
  Address_Line_2      VARCHAR(50)    , -- Says this field can be null
  City                VARCHAR(50)   NOT NULL,
  State_               CHAR(2)       NOT NULL,
  Zip                 CHAR(5)       NOT NULL,
  Birthdate           DATE          , -- Says this field can be null
  Stay_Credits_Earned NUMBER        DEFAULT 0,
  Stay_Credits_Used   NUMBER        DEFAULT 0,
  
  CONSTRAINT Customer_pk     PRIMARY KEY (Customer_ID) 
);

CREATE SEQUENCE customer_ID_seq
    START WITH 100001 INCREMENT BY 1;
    
    
-- Customer_Payments
CREATE TABLE Customer_Payments
(
  Payment_ID            NUMBER        NOT NULL, --primary key
  Customer_ID           NUMBER        NOT NULL, --foreign key
  Cardholder_First_Name VARCHAR(50)   NOT NULL,
  Cardholder_Mid_Name   VARCHAR(50)   ,
  Cardholder_Last_Name  VARCHAR(50)   NOT NULL,
  CardType              CHAR(4)       NOT NULL,
  CardNumber            NUMBER        NOT NULL,
  Expiration_Date       DATE          NOT NULL, 
  CC_ID                 NUMBER        NOT NULL,
  Billing_Address       VARCHAR(50)   NOT NULL,
  Billing_City          VARCHAR(50)   NOT NULL,
  Billing_State         CHAR(2)       NOT NULL,
  Billing_Zip           CHAR(5)       NOT NULL,
  
  CONSTRAINT Payments_pk     PRIMARY KEY (Payment_ID), 
  CONSTRAINT Payments_fk_Customers FOREIGN KEY (Customer_ID) REFERENCES Customers (Customer_ID)
);

CREATE SEQUENCE Payment_ID_seq
    START WITH 1 INCREMENT BY 1;
    
 -- Reservations   
CREATE TABLE Reservations
(
  Reservation_ID        NUMBER        NOT NULL, --primary key
  Customer_ID           NUMBER        NOT NULL, --foreign key
  Confirmation_Nbr      CHAR(8)       NOT NULL          UNIQUE,
  Date_Created          DATE          DEFAULT SYSDATE   NOT NULL,
  Check_In_Date         DATE          DEFAULT SYSDATE   NOT NULL,
  Check_Out_Date        DATE          , -- Says this field can be null
  Status                CHAR(1)       NOT NULL,
  Discount_Code         VARCHAR(50)   , -- Says this field can be null
  Reservation_Total     VARCHAR(50)   NOT NULL,
  Customer_Rating       NUMBER(1)     , -- Says this field can be null
  Notes                 VARCHAR(50)   , -- Says this field can be null
  
  
  CONSTRAINT Reservations_pk           PRIMARY KEY (Reservation_ID), 
  CONSTRAINT Reservations_fk_Customers FOREIGN KEY (Customer_ID) REFERENCES Customers (Customer_ID)
);

CREATE SEQUENCE Reservation_ID_seq
    START WITH 1 INCREMENT BY 1;


-- Locations
CREATE TABLE Locations
(
  Location_ID           NUMBER        NOT NULL, --primary key 
  Location_Name         VARCHAR(50)   NOT NULL  UNIQUE,
  Address               VARCHAR(50)   NOT NULL,
  City                  VARCHAR(50)   NOT NULL,
  State_                 CHAR(2)       NOT NULL,
  Zip                   CHAR(5)       NOT NULL,
  Phone                 CHAR(12)      NOT NULL,
  URL_                  VARCHAR(50)   NOT NULL,
  
  CONSTRAINT Locations_pk     PRIMARY KEY (Location_ID)
);

CREATE SEQUENCE Location_ID_seq
    START WITH 1 INCREMENT BY 1;
    

-- Rooms
CREATE TABLE Rooms
(
  Room_ID           NUMBER        NOT NULL, --primary key
  Location_ID       NUMBER        NOT NULL, --foreign key
  Floor             VARCHAR(50)   NOT NULL,
  Room_Number       NUMBER        NOT NULL,
  Room_Type         CHAR(1)       NOT NULL,
  Square_Footage    NUMBER        NOT NULL,
  Max_People        NUMBER        NOT NULL,
  Weekday_Rate      VARCHAR(50)   NOT NULL,
  Weekend_Rate      VARCHAR(50)   NOT NULL,
  
  CONSTRAINT Rooms_pk     PRIMARY KEY (Room_ID),
  CONSTRAINT Reservations_fk_Locations FOREIGN KEY (Location_ID) REFERENCES Locations (Location_ID)
);

CREATE SEQUENCE Room_ID_seq
    START WITH 1 INCREMENT BY 1;


-- Reservation_Details
CREATE TABLE Reservation_Details
(
  Reservation_ID        NUMBER        NOT NULL,
  Room_ID               NUMBER        NOT NULL,
  Number_of_Guests      NUMBER        NOT NULL,
  
  CONSTRAINT Reservation_Details_pk     PRIMARY KEY (Reservation_ID, Room_ID),
  CONSTRAINT Reservation_Details_fk     FOREIGN KEY (Reservation_ID) REFERENCES Reservations (Reservation_ID),
  CONSTRAINT Reservation_Details_fk_2   FOREIGN KEY (Room_ID) REFERENCES Rooms (Room_ID)
  
);

CREATE TABLE Features
(
  Feature_ID_       NUMBER        NOT NULL, --primary key
  Feature_Name     VARCHAR2(50)  NOT NULL     UNIQUE,

  CONSTRAINT Features_pk         PRIMARY KEY (Feature_ID_)
  
);

CREATE SEQUENCE Feature_ID_seq
    START WITH 1 INCREMENT BY 1;

CREATE TABLE Location_Features_Linking
(
  location_ID     NUMBER          NOT NULL,  
  Feature_ID_      NUMBER          NOT NULL,
  
  CONSTRAINT Location_Features_Linking_pk     PRIMARY KEY (Location_ID, Feature_ID_),
  CONSTRAINT Location_Features_Linking_fk     FOREIGN KEY (Location_ID) REFERENCES Locations (Location_ID),
  CONSTRAINT Location_Features_Linking_fk_2   FOREIGN KEY (Feature_ID_)  REFERENCES Features (Feature_ID_)
);


-- CHECK constraints --


ALTER TABLE Reservations
ADD CONSTRAINT Status_ck CHECK (Status = 'U' OR Status = 'I' OR Status = 'C' OR Status = 'N' OR Status = 'R');

ALTER TABLE Rooms
ADD CONSTRAINT Room_Type_ck CHECK (Room_Type = 'D' OR Room_Type = 'Q' OR Room_Type = 'K' OR Room_Type = 'S' OR Room_Type = 'C');

ALTER TABLE Customers 
ADD CONSTRAINT credits_ck CHECK (Stay_Credits_Used <= Stay_Credits_Earned);
 
ALTER TABLE Customers
ADD CONSTRAINT Email_ck CHECK (LENGTHB(Email) >= 7);


------------------------------------
-- Insert Data Section --
------------------------------------
-- Create the 3 locations mentioned in HW1 and make-up details on address, phone, and URL

-- Location 1
INSERT INTO Locations

VALUES(location_ID_seq.NEXTVAL, 'South Congress','323 S Congress Ave', 'Austin', 'TX','78731',
        '512-893-2348','www.southcongresshotel.com');

-- Location 2
INSERT INTO Locations

VALUES(location_id_seq.NEXTVAL, 'East 7th Lofts','348 E 7th St', 'Austin', 'TX','78705',
        '512-200-3291','www.e7lofts.com');

-- Location 3
INSERT INTO Locations

VALUES(location_id_seq.NEXTVAL, 'Balcones Canyonlands Cabins','82 Wooded Trl', 'Marble Falls', 'TX','78654',
        '830-981-1467','www.BCcabins.com');


-- Create 3 features that can be shared or unique to the locations but make sure 
-- at least one location has multiple features assigned to it

-- Feature 1
INSERT INTO Features
VALUES(feature_ID_seq.NEXTVAL, 'Free Wi-Fi');

-- Feature 2
INSERT INTO Features
VALUES(feature_ID_seq.NEXTVAL, 'Free Breakfast');

-- Feature 3
INSERT INTO features
VALUES(feature_ID_seq.NEXTVAL, 'Health Center');

-- Location 1 with Feature 1
-- South Congress w/ Free Wifi
INSERT INTO location_features_linking
VALUES(1, 1);

-- Location 2 with 2 Features
-- East 7th Lofts with Free Breakfast
INSERT INTO location_features_linking
VALUES(2, 2);

-- East 7th Lofts with Health Center
INSERT INTO location_features_linking
VALUES(2, 3);

-- Location 3 with 1 Feature
-- Balcones Canyonlands Cabins with Free Breakfast
INSERT INTO location_features_linking
VALUES(3, 2);

-- Create 2 rooms for each location (even though in reality there should be more)

-- rooms 234 & 450 at South Congress 
INSERT INTO rooms
VALUES(room_id_seq.NEXTVAL, 1, '2','234','Q', 400, 4, 104.56, 150.40);

INSERT INTO rooms
VALUES(room_id_seq.NEXTVAL, 1, '4', '450','D', 250, 2, 78.67, 100.59);

-- rooms 103 & 305 at East 7th Lofts
INSERT INTO rooms
VALUES(room_id_seq.NEXTVAL, 2, '1', '103','K', 300, 3, 89.70, 110.50);

INSERT INTO rooms
VALUES(room_id_seq.NEXTVAL, 2,'4', '450','S', 440, 4, 123.60, 170.90);

-- rooms 250 & 308 at BC Cabins
INSERT INTO rooms
VALUES(room_id_seq.NEXTVAL, 3, '2', '250','D', 425, 4, 105.89, 158.90);

INSERT INTO rooms
VALUES(room_id_seq.NEXTVAL, 3, '3', '308','K', 360, 2, 80.76, 107.60);

-- Create 2 customers.  The first customer should have your first and last name.  
-- Customer 1 

INSERT INTO customers
    VALUES(customer_id_seq.NEXTVAL,'Casey','Copeland','cmc6793@utexas.edu','903-707-1467',
    '1983 House St','Apt 301','Austin','TX',78705,'24-APR-1999',500,400);
    
-- Passenger 2
INSERT INTO customers
    VALUES(customer_id_seq.NEXTVAL,'Rhiannon','Pytlak','rhiannon@gmail.com','145-596-8740',
    '1102 SW Honey St', 'Apt 103','Austin','TX',78731,'16-NOV-1998',1000,100);

--Create payment info for the customers

-- payment 1, customer 1
INSERT INTO customer_payments
    VALUES(payment_id_seq.NEXTVAL,100001,'Casey','Michelle','Copeland','MSTR',
    5356890787172084,'04-DEC-2022',987,'5679 Burnet Rd','Austin','TX',78705);
    
-- payment 2, customer 2
INSERT INTO customer_payments
    VALUES(payment_id_seq.NEXTVAL,100002,'Rhiannon','Kayleigh','Pytlak','VISA',
    4927922408154735,'25-NOV-2021',169,'2934 Happy St','Austin','TX',78705);
    
-- Create Room Reservations, 1 for customer 1, 2 for customer 2 
-- customer 1
INSERT INTO reservations
    VALUES(reservation_id_seq.NEXTVAL, 100001,'G2JD8J3','05-OCT-2021','10-DEC-2021','12-DEC-2021',
    'U','HY89302X32',105.70,5,'Great place! Loved our stay!');
    
INSERT INTO reservation_details
    VALUES(1, 4, 2);

--customer 2
-- res 1
INSERT INTO reservations
    VALUES(reservation_id_seq.NEXTVAL, 100002,'A1L7Y69','09-SEP-2021','01-JAN-2022','03-JAN-2022',
    'U','PY89XKCOFS3',109.50, 4 ,'Had a good time!');

INSERT INTO reservation_details
    VALUES(2, 3, 2);

-- res 2
INSERT INTO reservations
    VALUES(reservation_id_seq.NEXTVAL, 100002,'P3R7Y9X','05-MAY-2021','06-JUN-2021','08-JUN-2021',
    'C','90POXK27DE9',80.67,3,'Very noisy area.');

INSERT INTO reservation_details
    VALUES(3, 2, 2);

COMMIT;
------------------------------------
-- Create Index Section --
------------------------------------
-- Indexes below are created for foreign keys that are not also primary keys to speed up data retrieval.

CREATE INDEX room_location_id_ix -- INDEX FOR fk (location_id) ON rooms TABLE
    ON rooms (location_id);

CREATE INDEX reservation_customer_id_ix -- INDEX for fk (customer_id) ON reservations TABLE
    ON reservations (customer_id, confirmation_Nbr);