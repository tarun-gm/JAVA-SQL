SELECT
b.flight_id,
p.full_name,
b.fare
FROM bookings b
JOIN passengers p ON p.passenger_id = b.passenger_id
WHERE b.fare > (
SELECT AVG(b2.fare)
FROM bookings b2
WHERE b2.flight_id = b.flight_id
)
ORDER BY b.flight_id, b.fare DESC;
