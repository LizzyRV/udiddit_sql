# Udiddit: A Social News Aggregator – SQL Refactoring Project

This project was developed as part of my SQL course at [Learn SQL Course by Udacity](https://www.udacity.com/course/learn-sql--nd072), where I applied advanced SQL and database modeling techniques to improve a poorly structured relational schema for a fictional social platform called **Udiddit**.

## Project Goals

- Analyze a poorly designed PostgreSQL schema (`bad_posts`, `bad_comments`)
- Normalize the schema into First, Second, and Third Normal Forms
- Apply constraints, foreign keys, and indexes to ensure data consistency and query performance
- Migrate real data from the old schema into the new one using `INSERT ... SELECT` logic and transformation functions

## Technologies Used

- PostgreSQL (v9.6+)
- SQL (DDL & DML)
- Regular Expressions in SQL
- Constraints and Indexes

---

## Part II: New Schema Design

The new schema follows normalization principles and supports the following features:

- Unique and validated usernames
- Unique topic names with optional descriptions
- Posts that contain either a URL or text, but never both
- Nested comment threads (using `parent_comment_id`)
- Votes stored as individual records (1 = upvote, -1 = downvote), with one vote per user per post
- Full referential integrity and cascading behaviors

The schema includes the following tables:

- `users`
- `topics`
- `posts`
- `comments`
- `votes`

See [`udiddit_schema.sql`](./udiddit_schema.sql)

---

## 🔄 Part III: Data Migration

The data from the original tables (`bad_posts`, `bad_comments`) was transformed and inserted into the new schema using advanced SQL features such as:

- `JOIN` to resolve foreign keys
- `regexp_split_to_table` to explode comma-separated vote lists
- `LEFT(..., 100)` to truncate titles exceeding the max length
- Filtering to ensure data consistency with defined `CHECK` constraints

See [`udiddit_migration.sql`](./udiddit_migration.sql)

---

## Final Row Counts

After migration:

| Table     | Rows     |
|-----------|----------|
| users     | 10,083   |
| topics    | 89       |
| posts     | 50,000   |
| comments  | 92,358   |
| votes     | 47,441   |

These counts confirm that the migration was successful and the new schema works as intended.

---

## What I Learned

- How to normalize and restructure databases using real-world constraints
- How to enforce data consistency with primary keys, foreign keys, `CHECK`, `NOT NULL`, and `UNIQUE`
- How to migrate and transform data using powerful SQL features like `JOIN`, `LATERAL`, and `regexp_split_to_table`
- How to write clean, documented, and maintainable SQL code

---

If you'd like to discuss this project or need help with SQL, feel free to reach out to me!

> *Created by Elizabeth Rojas – Junior Data Scientist