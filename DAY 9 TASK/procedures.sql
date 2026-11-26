USE telecom_db;
DELIMITER //

CREATE FUNCTION fn_validity_days_left(p_sub_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_days INT;
  SELECT GREATEST(p.validity_days - DATEDIFF(CURDATE(), s.last_recharge_date), 0)
    INTO v_days
  FROM subscribers s
  JOIN plans p ON p.plan_id = s.plan_id
  WHERE s.sub_id = p_sub_id;
  RETURN COALESCE(v_days, 0);
END //

CREATE PROCEDURE sp_recharge(
  IN  p_sub_id INT,
  IN  p_plan_id INT,
  IN  p_amount DECIMAL(10,2),
  OUT p_new_balance DECIMAL(10,2)
)
BEGIN
  DECLARE v_price DECIMAL(8,2);
  DECLARE v_type VARCHAR(10);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  IF p_amount IS NULL OR p_amount <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Recharge amount must be positive';
  END IF;

  SELECT price INTO v_price FROM plans WHERE plan_id = p_plan_id;
  IF v_price IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid plan';
  END IF;

  IF p_amount < v_price THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount is less than plan price';
  END IF;

  SELECT sub_type INTO v_type FROM subscribers WHERE sub_id = p_sub_id;
  IF v_type IS NULL OR v_type <> 'PREPAID' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not a valid prepaid subscriber';
  END IF;

  START TRANSACTION;
    UPDATE subscribers
       SET balance = balance + p_amount,
           plan_id = p_plan_id,
           last_recharge_date = CURDATE()
     WHERE sub_id = p_sub_id;

    INSERT INTO recharge_history (sub_id, plan_id, amount)
    VALUES (p_sub_id, p_plan_id, p_amount);
  COMMIT;

  SELECT balance INTO p_new_balance FROM subscribers WHERE sub_id = p_sub_id;
END //

DELIMITER ;

-- Test calls
SET @nb = 0;
CALL sp_recharge(1, 2, 199, @nb);
SELECT @nb AS new_balance;

CALL sp_recharge(1, 2, -5, @nb);
CALL sp_recharge(1, 99, 199, @nb);

-- Function used in a query
SELECT sub_id, full_name, balance, fn_validity_days_left(sub_id) AS days_left
FROM vw_prepaid_subscribers
WHERE fn_validity_days_left(sub_id) <= 5
ORDER BY days_left
LIMIT 20;
