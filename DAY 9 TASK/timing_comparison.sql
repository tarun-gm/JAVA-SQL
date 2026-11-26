USE telecom_db;

-- Method 1: cursor
TRUNCATE TABLE notifications;
SET @t1 = NOW(6);
CALL sp_notify_cursor();
SET @cursor_us = TIMESTAMPDIFF(MICROSECOND, @t1, NOW(6));

-- Method 2: single INSERT ... SELECT
TRUNCATE TABLE notifications;
SET @t2 = NOW(6);
INSERT INTO notifications (sub_id, message)
SELECT sub_id, CONCAT('Low balance: Rs.', balance, '. Please recharge.')
FROM vw_prepaid_subscribers
WHERE balance < 50;
SET @bulk_us = TIMESTAMPDIFF(MICROSECOND, @t2, NOW(6));

SELECT @cursor_us AS cursor_microseconds,
       @bulk_us   AS insert_select_microseconds,
       ROUND(@cursor_us / @bulk_us, 1) AS times_slower;
