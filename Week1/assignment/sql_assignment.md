# SQL Assignment — Week 1

You've just joined the data team at **Pathao**. Different teams keep coming to you with
questions about the `rides` table. Answer each one with a single SQL query.

Write your answers in [`sql_answers_template.sql`](sql_answers_template.sql) — rename it to
`sql_answers.sql` when you submit. Each question notes the concept it's testing and a rough
difficulty; they get harder as you go.

Q11 and Q12 need a **subquery** — a query nested inside another. That's a step beyond the SQL
pre-read, which stops at `HAVING`, so a bit of independent reading is expected there. The core
idea: a subquery in parentheses runs first (or, for a correlated subquery, once per outer row)
and its result is used by the outer query — as a single value, a list, or a per-row comparison.

Reference schema:

```sql
CREATE TABLE rides (
    ride_id          INTEGER       PRIMARY KEY,
    driver_name      VARCHAR(100)  NOT NULL,
    passenger_name   VARCHAR(100)  NOT NULL,
    pickup_city      VARCHAR(100)  NOT NULL,
    dropoff_city     VARCHAR(100)  NOT NULL,
    fare_amount      NUMERIC(10,2) NOT NULL CHECK (fare_amount >= 0),
    ride_distance_km NUMERIC(6,2)  NOT NULL CHECK (ride_distance_km >= 0),
    ride_status      VARCHAR(50)   NOT NULL DEFAULT 'pending'
                      CHECK (ride_status IN ('no_show', 'completed', 'cancelled')),
    requested_at      TIMESTAMP    NOT NULL,
    completed_at      TIMESTAMP,
    rating            NUMERIC(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
    payment_method    VARCHAR(50)
);
```

---

### Q1 — Kathmandu to Pokhara (Basic · DQL)

The support team is spot-checking pricing and wants every **completed** ride that went from
**Kathmandu to Pokhara**.

Return `ride_id`, `driver_name`, `passenger_name`, `fare_amount` for these rides.

---

### Q2 — Top 5 highest fares (Basic · DQL)

Finance is checking for pricing anomalies and wants to see the **5 most expensive rides ever
recorded**.

Return `driver_name`, `passenger_name`, `fare_amount`, ordered highest fare first.

---

### Q3 — The "Shrestha" complaint (Basic · DQL)

A passenger complaint mentions a driver named "shrestha" — they don't remember the full name or
how it was capitalized.

Return every ride where `driver_name` contains "shrestha", **regardless of case**.

---

### Q4 — How many rides were never rated? (Basic–Intermediate · NULL)

Product wants to know, out of all rides, how many were rated by the passenger and how many
weren't.

Return three columns in one query: `total_rides`, `rated_rides`, `unrated_rides`.

---

### Q5 — Every ride that wasn't paid in cash (Intermediate · NULL)

Finance wants every ride that was **not** paid by cash — including rides where the payment
method was never recorded at all, since those need investigating too.

Return `ride_id`, `driver_name`, `payment_method` for all such rides.

---

### Q6 — Revenue by pickup city (Intermediate · Aggregation)

The expansion team wants to know which pickup cities generate the most revenue, to decide where
to add more drivers.

For each `pickup_city`, return `total_rides`, `total_revenue` (sum of `fare_amount`), and
`avg_fare` (rounded to 2 decimals). Sort by `total_revenue`, highest first.

---

### Q7 — Drivers who qualify for the loyalty bonus (Intermediate · Aggregation)

HR is launching a bonus for drivers who have **completed more than 100 rides**.

Return `driver_name` and `completed_rides` for every driver with more than 100 completed rides
(`ride_status = 'completed'`). Sort by `completed_rides`, highest first.

---

### Q8 — Ride outcomes by status (Intermediate · Aggregation)

Ops wants to understand ride outcomes: for each `ride_status` (`completed`, `cancelled`,
`no_show`), how many rides fall into that bucket, and what's the average distance.

Return `ride_status`, `ride_count`, `avg_distance_km` (rounded to 2 decimals). Sort by
`ride_count`, highest first.

---

### Q9 — A new driver's first ride (Basic–Intermediate · DML)

A new driver, **Sunita Gurung**, just completed her first ride for passenger **Rajan Thapa**,
from **Lalitpur** to **Bhaktapur** — 12.4 km, fare NPR 350, requested and completed today. The
passenger hasn't rated it yet.

Two days later, the passenger comes back and rates the ride **4.8**.

Write two statements:
1. An `INSERT` adding the ride with `ride_id = 9001` and `rating` left `NULL`.
2. An `UPDATE` that sets `rating = 4.8` for that same ride — nothing else in the table should
   change.

---

### Q10 — Locking down payment methods (Intermediate · DDL)

Engineering just noticed that `payment_method` currently accepts **any text at all** — typos
have already caused reporting bugs (e.g. `'Esewa'`, `'e-sewa'`, `'ESEWA'` all showing up as
different values).

Write an `ALTER TABLE` statement that restricts `payment_method` to only:
`'cash'`, `'esewa'`, `'khalti'`, `'card'`, `'wallet'`.

Then write an `INSERT` using an invalid method (e.g. `'paypal'`) that you'd expect the database
to reject — add a comment noting the error you'd expect to see.

---

### Q11 — Rides priced above the platform average (Intermediate · Subquery)

Finance wants every ride priced **above the platform's overall average fare**, to review pricing
outliers. They don't want the average hardcoded — if new rides come in, the query should always
compare against the current average.

Return `ride_id`, `driver_name`, `fare_amount` for every ride where `fare_amount` is greater than
the average `fare_amount` across *all* rides. Use a subquery to compute that average — don't
compute it separately and paste in the number.

---

### Q12 — Each driver's single best ride (Intermediate · Correlated subquery)

Marketing wants to spotlight each driver's single highest-fare ride for a "driver of the month"
feature — one row per driver, not their whole ride history.

Return `driver_name`, `ride_id`, `fare_amount` for the one ride per driver where `fare_amount`
equals *that driver's own* maximum `fare_amount`. This needs a **correlated subquery** — one that
references the outer query's current row (e.g. `WHERE r2.driver_name = r.driver_name`) — because
"maximum fare" has to be recalculated separately for every driver.
