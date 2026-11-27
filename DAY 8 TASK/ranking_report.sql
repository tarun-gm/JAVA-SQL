SELECT
f.flight_code,
p.full_name,
b.fare,
RANK() OVER (PARTITION BY b.flight_id ORDER BY b.fare DESC) AS fare_rank,
DENSE_RANK() OVER (PARTITION BY b.flight_id ORDER BY b.fare DESC) AS fare_dense_rank
FROM bookings b
JOIN flights f ON f.flight_id = b.flight_id
JOIN passengers p ON p.passenger_id = b.passenger_id
ORDER BY f.flight_code, fare_rank;
