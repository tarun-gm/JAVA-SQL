-- run in terminal 1 (session a)
START TRANSACTION;

SELECT seat_id, status
FROM seats
WHERE flight_id = 101 AND seat_no = '12A'
FOR UPDATE;

-- start session b now, then come back and continue here
INSERT INTO bookings (booking_id, flight_id, passenger_id, seat_id, fare)
SELECT 8, 101, 5, seat_id, 5500.00
FROM seats
WHERE flight_id = 101 AND seat_no = '12A' AND status = 'AVAILABLE';

UPDATE seats
SET status = 'BOOKED'
WHERE flight_id = 101 AND seat_no = '12A' AND status = 'AVAILABLE';

COMMIT;

-- run in terminal 2 (session b), right after session a takes its lock
START TRANSACTION;

SELECT seat_id, status
FROM seats
WHERE flight_id = 101 AND seat_no = '12A'
FOR UPDATE;

-- this select waits until session a commits, then shows status = BOOKED
INSERT INTO bookings (booking_id, flight_id, passenger_id, seat_id, fare)
SELECT 9, 101, 6, seat_id, 5500.00
FROM seats
WHERE flight_id = 101 AND seat_no = '12A' AND status = 'AVAILABLE';

ROLLBACK;
