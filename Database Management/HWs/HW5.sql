SET SERVEROUTPUT ON;
SET DEFINE ON;


-- Question 1 part a: --
DECLARE
    count_reservations NUMBER;
BEGIN
    SELECT COUNT(customer_id)
    INTO count_reservations
    FROM reservation
    WHERE customer_id = '100002'; 
    
    IF count_reservations > 15 THEN
        DBMS_OUTPUT.PUT_LINE('The customer has placed more than 15 reservations.');
    ELSIF count_reservations <= 15 THEN
        DBMS_OUTPUT.PUT_LINE('The customer has placed 15 or fewer reservations.');   
    
    END IF;

END;
/

-- Question 1 part b, c, d --
DELETE FROM reservation_details WHERE reservation_id = 318;

ROLLBACK;

-- Question 2: --

DECLARE
    count_reservations NUMBER;
    customer_id_var VARCHAR(6) := &customer_id;

BEGIN
    
    SELECT COUNT(customer_id)
    INTO count_reservations
    FROM reservation
    WHERE customer_id = customer_id_var;
    
    IF count_reservations > 15 THEN
        DBMS_OUTPUT.PUT_LINE('The customer with customer ID: ' || customer_id_var || ' has placed more than 15 reservations.');
    ELSIF count_reservations <= 15 THEN
        DBMS_OUTPUT.PUT_LINE('The customer with customer ID: ' || customer_id_var || ' has placed 15 or fewer reservations.');   
    
    END IF;

END;
/

-- Question 3: --

BEGIN
  
    INSERT INTO customer VALUES (customer_id_seq.nextval , 'Rhiannon','Pytlak','rheepyt@gmail.com','903-707-1467','2313 Longview St','Apt 102','Austin','TX','78705',to_date('24-APR-99','DD-MON-RR'),24,0);
        DBMS_OUTPUT.PUT_LINE('1 row was inserted into the customer table.');
        
    COMMIT;

EXCEPTION
   
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');

END;
/


-- Question 4: --

DECLARE

    TYPE feature_table        IS TABLE OF VARCHAR(400);
    feature_collection        feature_table;
    feature_var               features.feature_name%TYPE;

BEGIN
        
    SELECT feature_name
    BULK COLLECT INTO feature_collection
    FROM features
    WHERE feature_name LIKE 'P%'
    ORDER BY feature_name ASC;

    FOR i IN 1..feature_collection.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Hotel feature '|| i || ': ' || feature_collection(i));
    END LOOP;
    
END;
/



-- Question 5 --
DECLARE 
    c VARCHAR2(1000) := '&d';
    
    CURSOR res_curs IS
        SELECT l.location_name, l.city, f.feature_name
        from location l left join location_features_linking lf on (l.location_id = lf. location_id) 
                        left join features f on (lf.feature_id = f.feature_id)
        where l.city LIKE c
        order by l.location_name, l.city, f.feature_name;
        
BEGIN
    FOR i in res_curs LOOP
        DBMS_OUTPUT.PUT_LINE(i.location_name || ' in ' || i.city || ' has feature: '|| i.feature_name);
    END LOOP;
    
END;
/

-- Question 6: --

CREATE OR REPLACE PROCEDURE insert_customer(
    f customer.first_name%TYPE,
    l customer.last_name%TYPE,
    e customer.email%TYPE,
    p customer.phone%TYPE,
    a customer.address_line_1%TYPE,
    c customer.city%TYPE,
    s customer.state%TYPE,
    z customer.zip%TYPE
)
AS
BEGIN  
    INSERT INTO Customer (CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, ADDRESS_LINE_1, CITY, STATE, ZIP)
    VALUES (customer_id_seq.nextval, f, l, e, p, a, c, s, z);

  DBMS_OUTPUT.PUT_LINE('1 row was inserted into the customer table.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');

END;
/

-- test
CALL insert_customer ( 'Casey', 'Ca', 'C@yahoo.com', '773-222-1111', 'Happy street', 'Dallas', 'TX', '111111');
BEGIN
Insert_customer ('Rhiannon', 'Py', 'R@yahoo.com', '773-222-1111', 'Happy street', 'Dallas', 'TX', '111111');
END;
/  

-- Question 7: --

CREATE OR REPLACE FUNCTION hold_count

(customer_id_param NUMBER)

RETURN NUMBER

AS

    total_num_rooms_var NUMBER;
    
BEGIN

    SELECT COUNT(customer_id)
    INTO total_num_rooms_var
    FROM reservation_details rd
        JOIN reservation r ON rd.reservation_id = r.reservation_id
    WHERE customer_id = customer_id_param;
    
RETURN total_num_rooms_var;

END;
/

-- test it

SELECT customer_id, hold_count(customer_id)  
FROM reservation
GROUP BY customer_id
ORDER BY customer_id;

ROLLBACK;
