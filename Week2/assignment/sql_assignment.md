# SQL Assignment — Week 2

It's week two at **Pathao**. The flat `rides` table you cleaned up last week is now a proper
relational schema — `drivers`, `passengers`, `locations`, `payment_methods`, and `trips` — and
different teams keep coming to you with questions that need more than one table at a time.

Write your answers in [`sql_answers_template.sql`](sql_answers_template.sql) — rename it to
`sql_answers.sql` when you submit. Each question notes the concept it's testing and a rough
difficulty; they get harder as you go.

Q12 needs **indexing and `EXPLAIN ANALYZE`** — a step beyond anything in this week's pre-reads,
same as the subquery questions were in Week 1. The core idea: `EXPLAIN ANALYZE` shows you the
actual plan Postgres used to run a query (a table scan? an index?) and how long each step took;
an index is a separate lookup structure Postgres can use instead of reading every row.

Reference schema (built in class in `Week2/day3_class_query.sql` / `Week2/migrations/`):

```sql
CREATE TABLE locations (
    location_id   SERIAL        PRIMARY KEY,
    city_name     VARCHAR(100)  NOT NULL UNIQUE
);

CREATE TABLE drivers (
    driver_id     SERIAL        PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL
);

CREATE TABLE passengers (
    passenger_id  SERIAL        PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL
);

CREATE TABLE payment_methods (
    payment_method_id  SERIAL       PRIMARY KEY,
    name                VARCHAR(30)  NOT NULL UNIQUE
);

CREATE TABLE trips (
    trip_id              SERIAL        PRIMARY KEY,
    driver_id            INTEGER       NOT NULL REFERENCES drivers(driver_id),
    passenger_id         INTEGER       NOT NULL REFERENCES passengers(passenger_id),
    pickup_location_id   INTEGER       NOT NULL REFERENCES locations(location_id),
    dropoff_location_id  INTEGER       NOT NULL REFERENCES locations(location_id),
    fare_amount          NUMERIC(10,2) NOT NULL CHECK (fare_amount > 0),
    distance_km          NUMERIC(6,2)  NOT NULL,
    status               VARCHAR(50)   NOT NULL CHECK (status IN ('completed', 'cancelled', 'no_show')),
    requested_at         TIMESTAMP     NOT NULL,
    completed_at         TIMESTAMP,
    rating               NUMERIC(2,1)  CHECK (rating BETWEEN 1.0 AND 5.0),
    payment_method_id    INTEGER       REFERENCES payment_methods(payment_method_id)
);
```

Q1 and Q2 also touch two columns on the original `rides` table from Week 1: `driver_name` and
`payment_method` (full schema in the [Week 1 SQL assignment](../../Week1/assignment/sql_assignment.md)).

---

### Q1 — Standardizing driver names from the raw feed (Basic · String functions)

The onboarding team is looking at the original `rides` import — before your Week 2 normalization
— and wants a clean list of driver names: extra whitespace collapsed to a single space, trimmed,
and title-cased. Exactly the cleanup your `drivers` table already got.

Return one column, `clean_driver_name`, with every **distinct** cleaned name from
`rides.driver_name`, sorted alphabetically.

---

### Q2 — Every payment method actually in use (Basic · String functions)

Finance wants a case-insensitive, deduplicated list of payment methods from the raw `rides`
feed — the same messiness (`'esewa'`, `'Esewa'`, `'ESEWA'`) your `payment_methods` table was
built to fix.

Return one column, `payment_method`, lowercased and deduplicated, sorted alphabetically.

---

### Q3 — A readable log of every completed trip (Basic · Joins)

Ops wants a human-readable log of completed trips — names and city names, not foreign key ids.

Return `driver_name`, `passenger_name`, `pickup_city`, `dropoff_city`, `fare_amount`, and
`requested_at` for every trip with `status = 'completed'`. You'll need to join `locations` in
**twice** — once for pickup, once for dropoff — so give each join its own alias.

---

### Q4 — Drivers who have never driven a single trip (Basic–Intermediate · Joins)

Retention wants to reach out to drivers who signed up but have **never once** been assigned a
trip — not even a cancelled or no-show one.

Return `driver_name` for every driver with zero rows in `trips` at all. Use a join — not a
subquery — and explain in a one-line comment why an `INNER JOIN` can't answer this question.

---

### Q5 — Payment methods nobody has ever used (Intermediate · Joins)

Finance is reviewing whether every row in `payment_methods` is actually used anywhere, or if
some are dead entries worth removing.

Return `payment_method_id` and `name` for every payment method with **zero** trips recorded
against it. In a comment, note which join type you'd need (and which table you'd start `FROM`)
if you wrote this the other way around — keeping every `payment_methods` row and matching out to
`trips`.

---

### Q6 — Numbering each driver's trips in order (Basic–Intermediate · Window functions)

Ops wants each driver's trips numbered in the order they were requested — trip 1, trip 2, trip
3 — restarting at 1 for every driver, without collapsing any trip-level detail.

Return `driver_name`, `requested_at`, `fare_amount`, and `trip_number` for every trip, numbered
per driver with `ROW_NUMBER()`. Sort by driver, then `trip_number`.

---

### Q7 — Each driver's running earnings (Intermediate · Window functions)

Finance wants to see, trip by trip, how each driver's earnings accumulate over time — not just
the final total.

Return `driver_name`, `requested_at`, `fare_amount`, and `running_total` — that driver's
cumulative `fare_amount` up to and including that trip, ordered by `requested_at`.

---

### Q8 — Each driver's single highest-fare trip, without a subquery (Intermediate · Window functions)

Marketing wants each driver's single highest-fare trip — one row per driver — for a "driver of
the month" feature. You could do this with a correlated subquery (like Week 1's Q12), but this
time do it with a **window function** instead.

Return `driver_name`, `trip_id`, `fare_amount` for the one row per driver with that driver's
highest `fare_amount`. You'll need `RANK()` or `ROW_NUMBER()` inside a subquery or CTE — a window
function's result can't be filtered directly in the same query's `WHERE` clause.

---

### Q9 — Driver performance scorecard (Intermediate · Conditional aggregation)

Ops wants one row per driver summarizing performance — total trips, completed trips, cancelled
trips, cancellation rate, and average rating — in a single query, not five separate ones.

Return `driver_name`, `total_trips`, `completed_trips`, `cancelled_trips`,
`cancellation_rate` (percentage, 2 decimals), and `avg_rating` (2 decimals, over rated trips
only). Use `CASE WHEN` or `FILTER` inside your aggregates. Include drivers with zero trips —
don't let a divide-by-zero crash the query.

---

### Q10 — Onboarding a new driver atomically (Intermediate · Transactions)

A new driver, **Sunita Gurung**, is being registered along with her first three trips (make up
any reasonable pickup/dropoff/fare/distance/status/`requested_at` values). The onboarding script
must be atomic: if any one statement fails, **none** of it — not even the new driver row —
should be left behind.

Write this as a single transaction: `BEGIN`, the driver `INSERT`, three trip `INSERT`s, then
`COMMIT`. In a comment, note what you'd change to deliberately trigger a rollback (e.g. an
invalid `status` value on the third trip), and what you'd expect to happen to the driver row if
that statement fails before `COMMIT`.

---

### Q11 — A saved view for the ops dashboard (Intermediate · Views)

The ops team keeps re-running the same cancellation-rate check by hand and wants it saved as a
view instead of retyped every time.

Write a `CREATE VIEW driver_cancellation_summary AS ...` returning, per driver: `driver_name`,
`total_trips`, `cancelled_trips`, and `cancellation_rate` (2 decimals) — same calculation as Q9.
Then write the `SELECT` you'd run against that view to find drivers with a cancellation rate
above 20%.

---

### Q12 — Speeding up a slow driver lookup (Intermediate · Indexing — a step beyond the pre-reads)

Support keeps looking up all trips for a single driver, and on a `trips` table with a few
million rows, that query is noticeably slow.

1. Run `EXPLAIN ANALYZE` on `SELECT * FROM trips WHERE driver_id = <pick any real driver_id>` and
   note the scan type and execution time in a comment.
2. Create an index that would speed up this exact lookup.
3. Re-run the same `EXPLAIN ANALYZE` and note, in a comment, what changed in the plan and the
   execution time.
