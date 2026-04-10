# UniCycle Infrastructure

Welcome to the infrastructure repository for **UniCycle**, the open-source, student-exclusive marketplace application 

This repository orchestrates our local development environment. It uses Docker Compose to seamlessly link our React/Vite frontend, Kotlin Spring Boot backend, and PostgreSQL database together on a private internal network.

---

## Required Folder Structure

For Docker Compose to successfully find and build the frontend and backend containers, **you must clone all three UniCycle repositories into the same parent folder.** Your local workspace should look exactly like this before you attempt to run the project:

```text
UniCycle/                        <-- Your parent workspace folder
├── UniCycle-Infra/              <-- THIS repository
│   ├── docker-compose.yml
│   └── .env.example
├── UniCycle-FE/                 <-- The React Monorepo
│   ├── apps/
│   ├── packages/
│   └── Dockerfile
└── UniCycle-BE/                 <-- The Spring Boot API
    ├── src/
    └── Dockerfile
```

---

## Local Setup Guide
1. **Prerequisites**
  - Ensure you have Docker Desktop installed and running on your machine.
  - Ensure you have Git installed.

2. **Configure Your Environment Variables**

We use a `.env` file to securely inject database passwords into the containers without exposing them. 
- Open the `UniCycle-Infra` folder in your code editor.
- Duplicate the `.env.example` file and rename the new file to exactly `.env`.
- Open your new `.env` file and fill in your own secure local passwords.
  (Note: This `.env` file is ignored by Git, so your credentials are safe)

3. **Boot Up the Stack**

Open your terminal, navigate into the `UniCycle-Infra` directory, and run:

```Bash
docker-compose up --build
```
What this does:
  1. Downloads and starts the PostgreSQL database.
  2. Compiles the Kotlin Spring Boot backend and runs all pending Flyway database migrations.
  3. Compiles the React Vite frontend and wraps it in an Nginx reverse-proxy.
     
Once the terminal output settles, you can access the UniCycle marketplace in your browser at: http://localhost:3000

## Helpful Docker Commands

When you are done developing for the day, you can shut down the environment using `CTRL+C` in your terminal, or by running this command in the `UniCycle-Infra` folder:

```Bash
docker-compose down
```
### Need to wipe your database?

If you ever need to completely destroy your local PostgreSQL database and start fresh (e.g., if a migration fails or you want to clear all mock data), run the down command with the -v (volume) flag:

```Bash
docker-compose down -v
```
Warning: This permanently deletes all local database tables and rows.
