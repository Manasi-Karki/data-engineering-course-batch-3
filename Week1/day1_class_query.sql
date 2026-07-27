create database ride_share;

CREATE TABLE rides (
    ride_id          INTEGER       PRIMARY KEY,
    driver_name      VARCHAR(100)          NOT NULL,
    passenger_name   VARCHAR(100)          NOT NULL,
    pickup_city      VARCHAR(100)          NOT NULL,
    dropoff_city     VARCHAR(100)          NOT NULL,
    fare_amount      NUMERIC(10,2) NOT NULL CHECK (fare_amount >= 0),
    ride_distance_km NUMERIC(6,2)  NOT NULL CHECK (ride_distance_km >= 0),
    ride_status      VARCHAR(50)   NOT NULL default 'pending' CHECK (ride_status IN ('no_show', 'completed', 'cancelled')),
    requested_at     TIMESTAMP     NOT NULL,
    completed_at     TIMESTAMP,
    rating           NUMERIC(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
    payment_method   VARCHAR(50)
);



COPY rides FROM '/data/rides.csv' CSV HEADER NULL '';


SELECT ride_id , driver_name ,
passenger_name 
FROM rides r ;

SELECT *
FROM rides r 
WHERE ride_status = 'cancelled'
AND payment_method = 'esewa'

SELECT
	ride_status,
	count(*)
FROM
	rides
GROUP BY
	ride_status ;


SELECT
	driver_name ,
	ride_status,
	count(*)
FROM
	rides
GROUP BY
	ride_status,
	driver_name 
ORDER BY driver_name DESC , ride_status ;


SELECT
	driver_name ,
	ride_status,
	count(*) total_count 
FROM
	rides
GROUP BY
	ride_status,
	driver_name
ORDER BY total_count DESC ;

SELECT
	driver_name ,
	ride_status,
	count(*) total_count 
FROM
	rides
GROUP BY
	ride_status,
	driver_name
HAVING count(*) > 150
ORDER BY total_count DESC ;
