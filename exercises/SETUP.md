# Setup

Do this once before [Exercise 1](part-a/exercise1-put-your-data-under-contract.md). You need [Docker](https://www.docker.com/) (with Docker Compose) and [uv](https://docs.astral.sh/uv/), see the [prerequisites](/README.md#prerequisites).

> [!IMPORTANT]
> **Cannot install anything on your laptop?** Skip this setup and do Exercises 1 and 2 in the hosted [Data Contract Editor](https://editor.datacontract.com), see the note at the top of [Exercise 1](part-a/exercise1-put-your-data-under-contract.md).


## Get the Repository

1. Clone the workshop repository and change into it:

   ```bash
   git clone https://github.com/datacontract/workshop-data2day-2026.git
   cd workshop-data2day-2026
   ```


## Install the CLIs

2. Run the install script. It installs the Data Contract CLI (`datacontract`), the Data Product CLI (`dataproduct`), and the Entropy Data CLI (`entropy-data`, only needed for Part D), and pre-pulls the PostgreSQL image:

   ```bash
   scripts/install.sh
   ```

   This might take a few minutes.

   > **Windows?** Run `scripts\install.bat` instead. It works in both cmd and PowerShell (PowerShell-only alternative: `scripts\install.ps1`). All other commands in this workshop need **Git Bash**, see the note in the [README](/README.md#prerequisites).

3. Open a **new terminal** (to update your `PATH`), go to the repository folder, and check the versions:

   ```bash
   datacontract --version
   dataproduct --version
   ```

   You should see `1.2.3` and `0.3.1`. If a command is not found, run `uv tool update-shell` and open a new terminal.


## Start the Database

4. Start PostgreSQL with the preloaded e-commerce data:

   ```bash
   docker compose up -d
   ```

   It runs on `localhost:5433`:

   - **Host**: `localhost`
   - **Port**: `5433`
   - **Database**: `workshop`
   - **Username**: `workshop`
   - **Password**: `workshop`

   It holds two schemas, `orders_v1` and `orders_v2`, each with `orders` and `line_items` tables.

5. Check that it works:

   ```bash
   docker compose exec postgres psql -U workshop -d workshop -c 'SELECT COUNT(*) FROM orders_v1.orders;'
   ```

   You should see `5000`.

Open a SQL prompt with `docker compose exec postgres psql -U workshop -d workshop`.
To reset the database, run `docker compose down && docker compose up -d`.

You are ready for [Exercise 1](part-a/exercise1-put-your-data-under-contract.md).
