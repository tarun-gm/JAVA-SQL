USE telecom_db;
DELIMITER //

CREATE PROCEDURE sp_notify_cursor()
BEGIN
  DECLARE v_sub INT;
  DECLARE v_bal DECIMAL(10,2);
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT sub_id, balance FROM vw_prepaid_subscribers WHERE balance < 50;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO v_sub, v_bal;
    IF done = 1 THEN LEAVE read_loop; END IF;
    INSERT INTO notifications (sub_id, message)
    VALUES (v_sub, CONCAT('Low balance: Rs.', v_bal, '. Please recharge.'));
  END LOOP;
  CLOSE cur;
END //

DELIMITER ;
