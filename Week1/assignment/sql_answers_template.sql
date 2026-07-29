-- Week 1 SQL Assignment — Answers
-- Fill in each query below. See sql_assignment.md for the full scenario text.
-- Rename this file to sql_answers.sql before committing.


-- Q1 — Kathmandu to Pokhara (Basic · DQL)
-- Completed rides from Kathmandu to Pokhara: ride_id, driver_name, passenger_name, fare_amount



-- Q2 — Top 5 highest fares (Basic · DQL)
-- driver_name, passenger_name, fare_amount — 5 highest fares, descending



-- Q3 — The "Shrestha" complaint (Basic · DQL)
-- Every ride where driver_name contains "shrestha", case-insensitive



-- Q4 — How many rides were never rated? (Basic–Intermediate · NULL)
-- One query returning: total_rides, rated_rides, unrated_rides



-- Q5 — Every ride that wasn't paid in cash (Intermediate · NULL)
-- ride_id, driver_name, payment_method — not cash, including unrecorded payment methods



-- Q6 — Revenue by pickup city (Intermediate · Aggregation)
-- pickup_city, total_rides, total_revenue, avg_fare (2 decimals) — sorted by total_revenue desc



-- Q7 — Drivers who qualify for the loyalty bonus (Intermediate · Aggregation)
-- driver_name, completed_rides — drivers with more than 100 completed rides, sorted desc



-- Q8 — Ride outcomes by status (Intermediate · Aggregation)
-- ride_status, ride_count, avg_distance_km (2 decimals) — sorted by ride_count desc



-- Q9 — A new driver's first ride (Basic–Intermediate · DML)
-- 9a. INSERT the new ride (ride_id 9001, rating NULL)


-- 9b. UPDATE the rating to 4.8 for ride_id 9001



-- Q10 — Locking down payment methods (Intermediate · DDL)
-- 10a. ALTER TABLE to restrict payment_method to a fixed set of values


-- 10b. INSERT using an invalid payment method — note the error you'd expect in a comment



-- Q11 — Rides priced above the platform average (Intermediate · Subquery)
-- ride_id, driver_name, fare_amount — fare_amount above the average of ALL rides (via subquery)



-- Q12 — Each driver's single best ride (Intermediate · Correlated subquery)
-- driver_name, ride_id, fare_amount — one row per driver, their own max fare_amount

