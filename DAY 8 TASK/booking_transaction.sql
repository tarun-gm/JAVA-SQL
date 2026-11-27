START TRANSACTION;

SELECT seat_id, status
FROM seats
WHERE flight_id = 101 AND seat_no = '12A'
FOR UPDATE;

INSERT INTO bookings (booking_id, flight_id, passenger_id, seat_id, fare)
SELECT 1, 101, 1, seat_id, 5500.00
FROM seats
WHERE flight_id = 101 AND seat_no = '12A' AND status = 'AVAILABLE';

UPDATE seats
SET status = 'BOOKED'
WHERE flight_id = 101 AND seat_no = '12A' AND status = 'AVAILABLE';

COMMIT;
