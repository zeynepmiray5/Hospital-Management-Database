# Hospital Management Database

A relational database project designed to manage the core operations of a hospital using MySQL.

The project focuses on database design, data integrity, relationships between entities, and business-rule enforcement through SQL constraints and triggers.

## Features

- **Staff Management:** Manage doctors, nurses, management staff, and support personnel.
- **Patient Management:** Store and organize patient records.
- **Operations:** Track consultations, treatments, and planned medical operations.
- **Surgery Scheduling:** Manage surgery rooms, schedules, surgeons, and assistants.
- **Emergency Management:** Record emergency cases, diagnoses, and assigned medical staff.
- **Leave Management:** Handle employee leave requests, approvals, and rejections.
- **Financial Tracking:** Record hospital revenues and expenses.
- **Population Counters:** Automatically maintain active employee and patient counts using triggers.

## Technologies

- MySQL 8.0.16+
- SQL
- Database Constraints
- Foreign Keys
- Triggers

## Database Concepts

This project demonstrates the use of:

- Primary Keys and Foreign Keys
- UNIQUE and CHECK Constraints
- AUTO_INCREMENT
- BEFORE and AFTER Triggers
- Conditional validation using IF / ELSEIF
- SIGNAL SQLSTATE for custom error handling
- Relational data management
- JOIN and aggregate queries

## Database Diagram

![ER Diagram](images/er-diagram.png) 

## Business Rules and Validations

Several business rules are implemented directly at the database level.

Examples include:

- A doctor cannot be assigned to an operation outside their employment period.
- A doctor cannot be assigned to an operation during approved leave.
- Two surgeries cannot use the same operating room at overlapping times.
- A doctor or patient cannot be assigned to multiple simultaneous surgeries.
- Surgery information is automatically populated from the related operation.
- An employee's active status affects the corresponding population counter.
- Leave requests must follow date, approval, and employee-assignment rules.

## Main Relationships

- Each doctor belongs to a department.
- A nurse can be assigned to a doctor.
- An operation links one doctor with one patient.
- A surgery record extends an operation (one-to-one via op_id).
- Revenue is recorded per surgery operation.
- Leave requests (off_days) belong to a doctor, nurse, staff member, or manager and are approved by a manager.

## Project Structure

```
hospital-management-database/
├── README.md
├── sql/
│   └── Hospital_Database.sql
└── images/
    └── er-diagram.png
```


## Getting Started

1. Install MySQL Server 8.0.16 or later.
2. Open the SQL script using a MySQL-compatible client.
3. Execute the script to create the database, tables, triggers, and sample records.
4. Run the SELECT queries at the end of the script to explore the database.
5. Commented test examples at the end of the script show how the triggers reject invalid data.

**Warning:** The script starts by dropping the existing `HOSPITAL` database, if one exists. Executing it will delete the existing database and its contents. Use a test environment only.

## Sample Data

The script includes sample records for testing relationships, constraints, and trigger behavior.

All people, names, ID numbers, and other personal data in this database are fictional and were created for demonstration purposes only. Any resemblance to real persons is purely coincidental.

## Project Status

This is an educational project developed to practice relational database design and MySQL programming. It is not intended for production use.

