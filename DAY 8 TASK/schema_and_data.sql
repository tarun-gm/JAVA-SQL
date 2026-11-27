CREATE TABLE flights (
flight_id INT PRIMARY KEY,
flight_code VARCHAR(10) NOT NULL,
origin VARCHAR(30) NOT NULL,
destination VARCHAR(30) NOT NULL
);

CREATE TABLE passengers (
passenger_id INT PRIMARY KEY,
full_name VARCHAR(50) NOT NULL
);

CREATE TABLE seats (
seat_id INT PRIMARY KEY,
flight_id INT NOT NULL REFERENCES flights(flight_id),
seat_no VARCHAR(5) NOT NULL,
status VARCHAR(10) NOT NULL DEFAULT 'AVAILABLE',
UNIQUE (flight_id, seat_no)
);

CREATE TABLE bookings (
booking_id INT PRIMARY KEY,
flight_id INT NOT NULL REFERENCES flights(flight_id),
passenger_id INT NOT NULL REFERENCES passengers(passenger_id),
seat_id INT NOT NULL UNIQUE REFERENCES seats(seat_id),
fare DECIMAL(10,2) NOT NULL,
booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO flights VALUES
(101, 'AI101', 'CHENNAI', 'DELHI'),
(102, 'AI202', 'CHENNAI', 'MUMBAI');

INSERT INTO passengers VALUES
(1, 'ARUN'), (2, 'BHAVANA'), (3, 'CHITRA'),
(4, 'DEEPAK'), (5, 'ELANGO'), (6, 'FARAH');

INSERT INTO seats VALUES
(1, 101, '12A', 'AVAILABLE'),
(2, 101, '12B', 'BOOKED'),
(3, 101, '12C', 'BOOKED'),
(4, 101, '12D', 'BOOKED'),
(5, 102, '5A', 'BOOKED'),
(6, 102, '5B', 'BOOKED'),
(7, 102, '5C', 'BOOKED');

INSERT INTO bookings (booking_id, flight_id, passenger_id, seat_id, fare) VALUES
(2, 101, 2, 2, 7200.00),
(3, 101, 3, 3, 7200.00),
(4, 101, 4, 4, 4800.00),
(5, 102, 5, 5, 6100.00),
(6, 102, 6, 6, 6100.00),
(7, 102, 1, 7, 3900.00);
