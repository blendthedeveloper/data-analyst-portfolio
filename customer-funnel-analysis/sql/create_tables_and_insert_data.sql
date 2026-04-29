
create_tables_and_insert_data.sql

-- ============================================
-- TABLE CREATION
-- ============================================

CREATE TABLE events(
    user_id INT,
    event_type VARCHAR(50),
    event_time DATETIME
);

CREATE TABLE orders(
    order_id INT,
    customer_id INT,
    order_date VARCHAR(50),
    amount INT
);

CREATE TABLE payments(
    order_id INT,
    payment_status VARCHAR(50)
);

CREATE TABLE user_mapping(
    user_id INT,
    customer_id INT
);

-- ============================================
-- INSERT DATA
-- ============================================

-- events
INSERT INTO events VALUES
(1,'visit','2024-01-01'),
(1,'add_to_cart','2024-01-01'),
(1,'purchase','2024-01-01'),

(2,'visit','2024-01-02'),
(2,'add_to_cart','2024-01-02'),

(3,'visit','2024-01-03'),

(4,'purchase','2024-01-04'),

(5,'visit','2024-01-05'),
(5,'add_to_cart','2024-01-05'),
(5,'purchase','2024-01-05'),

(6,'visit','2024-01-06'),

(7,'add_to_cart','2024-01-07'),

(8,'visit','2024-01-08'),
(8,'purchase','2024-01-08');

-- orders
INSERT INTO orders VALUES
(1,101,'2024-01-01',500),
(2,102,'2024-01-02',300),
(3,101,'2024-01-05',700),
(4,103,'2024-01-07',200),
(5,104,'2024-01-10',1000),
(6,102,'2024-01-12',400),
(7,105,'2024-01-15',-50),
(8,101,'invalid_date',600),
(9,106,'2024-01-20',800),
(10,101,'2024-01-01',500);

-- payments
INSERT INTO payments VALUES
(1,'Success'),
(2,'Failed'),
(3,'Success'),
(4,'Success'),
(5,'Failed'),
(6,'Success'),
(7,'Success'),
(8,'Failed'),
(9,'Success'),
(10,'Success');

-- mapping
INSERT INTO user_mapping VALUES
(1,101),
(2,102),
(3,103),
(4,104),
(5,105),
(6,106),
(7,107),
(8,108);