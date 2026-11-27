WITH fare_data AS (
SELECT
b.booking_id,
b.flight_id,
f.flight_code,
p.full_name,
b.fare
FROM bookings b
JOIN flights f ON f.flight_id = b.flight_id
JOIN passengers p ON p.passenger_id = b.passenger_id
)
SELECT
flight_code,
full_name,
fare,
RANK() OVER (PARTITION BY flight_id ORDER BY fare DESC) AS fare_rank,
DENSE_RANK() OVER (PARTITION BY flight_id ORDER BY fare DESC) AS fare_dense_rank,
SUM(fare) OVER (
PARTITION BY flight_id
ORDER BY booking_id
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_revenue
FROM fare_data
ORDER BY flight_code, booking_id;
