# Week 2 Assignment

SQL only this week — 12 scenario-based questions against the normalized schema you built in
class, covering:

1. **[SQL string functions — Cheatsheet](../week2_string_functions_cheatsheet.html)** (`LOWER`, `TRIM`, `INITCAP`, `REGEXP_REPLACE`)
2. **[SQL Joins — Pre-read](../week2_joins_preread.html)** (`INNER`/`LEFT`/`RIGHT`/`FULL OUTER JOIN`, anti-patterns)
3. **[SQL Window Functions — Cheatsheet](../week2_window_functions_cheatsheet.html)** (`ROW_NUMBER`, `RANK`/`DENSE_RANK`, running totals, `LAG`)

plus conditional aggregation, transactions, and views straight from class (`day4_class_query.sql`).
The last question adds **indexing and `EXPLAIN ANALYZE`** — a step beyond anything in this week's
pre-reads, same as the subquery questions were in Week 1.

See **[sql_assignment.md](sql_assignment.md)** for the full question text and reference schema.

## Dataset

Everything runs against the normalized schema from class: `drivers`, `passengers`, `locations`,
`payment_methods`, and `trips`. Q1 and Q2 also need the original flat `rides` table from Week 1.

If your local database doesn't have the Week 1 `rides` table yet:

```bash
psql -U postgres -d ride_share -f Week1/create_ride.sql
psql -U postgres -d ride_share -c "\copy rides FROM 'Week1/rides.csv' CSV HEADER NULL ''"
```

Then build the Week 2 schema by running the migrations in order:

```bash
for f in Week2/migrations/*.sql; do psql -U postgres -d ride_share -f "$f"; done
```

(This is the same schema `Week2/day3_class_query.sql` walks through interactively in class — the
migrations folder is just the clean, idempotent version of the same five `CREATE TABLE` /
`INSERT` steps.)

## What to submit

- `sql_answers.sql` — your 12 SQL answers, filled in from `sql_answers_template.sql`

Lives in this `Week2/assignment/` folder.

## How to submit

Same workflow as Week 1:

```bash
git checkout main
git pull upstream main            # make sure you're on the latest material
git checkout -b week2-assignment

# ... fill in sql_answers.sql ...

git add Week2/assignment/sql_answers.sql
git commit -m "Complete week 2 SQL assignment"
git push -u origin week2-assignment
```

Then open a pull request **on your own fork** — base: `main`, compare: `week2-assignment` — and
share the link with your instructor.
