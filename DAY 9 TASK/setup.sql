CREATE DATABASE IF NOT EXISTS telecom_db;
USE telecom_db;

CREATE TABLE plans (
  plan_id INT PRIMARY KEY,
  plan_name VARCHAR(50),
  price DECIMAL(8,2),
  validity_days INT
);

CREATE TABLE subscribers (
  sub_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(80),
  phone VARCHAR(15),
  sub_type ENUM('PREPAID','POSTPAID'),
  plan_id INT,
  balance DECIMAL(10,2) DEFAULT 0,
  last_recharge_date DATE,
  id_proof_no VARCHAR(20),
  FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

CREATE TABLE recharge_history (
  recharge_id INT AUTO_INCREMENT PRIMARY KEY,
  sub_id INT,
  plan_id INT,
  amount DECIMAL(10,2),
  recharged_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
  notif_id INT AUTO_INCREMENT PRIMARY KEY,
  sub_id INT,
  message VARCHAR(200),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO plans VALUES
(1,'Basic',99,28),(2,'Standard',199,56),(3,'Premium',399,84);

SET SESSION cte_max_recursion_depth = 20000;
INSERT INTO subscribers (full_name, phone, sub_type, plan_id, balance, last_recharge_date, id_proof_no)
WITH RECURSIVE n AS (
  SELECT 1 AS i UNION ALL SELECT i+1 FROM n WHERE i < 10000
)
SELECT CONCAT('Subscriber ', i),
       CONCAT('9', LPAD(i, 9, '0')),
       IF(i % 5 = 0, 'POSTPAID', 'PREPAID'),
       (i % 3) + 1,
       ROUND(RAND() * 200, 2),
       CURDATE() - INTERVAL (i % 40) DAY,
       CONCAT('ID', LPAD(i, 8, '0'))
FROM n;
