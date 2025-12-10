# Airflow Proof of Concept

## Proof of Concept Project
- Minimal Apache Airflow 3.1.3 environment using Docker/Podman compose.
- Containers: Airflow webserver, scheduler, Redis, PostgreSQL.
- Windows-friendly automation via `scripts/start-airflow-poc.bat` and `scripts/cleanup-airflow-poc.bat`.
- Sample DAG (`dags/example_poc_dag.py`) to validate task execution.

## What this PoC shows
- Bootstraps Airflow 3.1.3 with CeleryExecutor, PostgreSQL metadata database, and Redis broker.
- Seeds an admin user (`admin` / `admin`) and default connections for immediate login.
- Demonstrates DAG discovery with a simple example workflow.
- Runs with either Docker or Podman using the same compose definition.

## Files provided
- `docker-compose.yml` — Compose stack for Airflow, PostgreSQL, and Redis.
- `dags/example_poc_dag.py` — Example DAG that prints PoC markers.
- `scripts/start-airflow-poc.bat` — Launch script that detects Docker/Podman and starts the stack.
- `scripts/cleanup-airflow-poc.bat` — Cleanup script to tear down containers, networks, and volumes.

## How to Run
### Pre-requisites
- Windows, macOS, or Linux with Docker or Podman installed (compose plugin required).
- Network access to pull images from Docker Hub.

### Start the PoC
1. Open a command window in the directory containing the repository files.
2. Run `scripts\start-airflow-poc.bat`.
3. The script will:
   - Detect Docker or Podman.
   - Pull required images.
   - Initialize the Airflow database and admin user.
   - Start the webserver, scheduler, Redis, and PostgreSQL containers.

### Verify
- Airflow UI: `http://localhost:8080` (username `admin`, password `admin`).
- Confirm the `airflow_poc_demo` DAG appears and can be triggered manually.

## Ports & Containers
| Component | Container Name | Host:Container | Notes |
| --- | --- | --- | --- |
| PostgreSQL | `airflow-poc-test-postgres-1` | `5432:5432` (internal unless published) | DB name/user/password: `airflow` |
| Redis | `airflow-poc-test-redis-1` | internal | Broker for Airflow background tasks |
| Airflow Webserver | `airflow-poc-test-airflow-webserver-1` | `8080:8080` | Admin login: `admin` / `admin` |
| Airflow Scheduler | `airflow-poc-test-airflow-scheduler-1` | internal | Executes DAG tasks |

> Container names may include a project prefix depending on compose version; adjust accordingly when inspecting resources.

## Cleanup
Run `scripts\cleanup-airflow-poc.bat` from the repository root to remove:
- Containers and networks created by the compose stack.
- Volumes (`airflow-logs`, `airflow-config`, `postgres-data`).
- Local images pulled for the PoC (via `--rmi local`).

## Downloads
All required files (`docker-compose.yml`, `dags/`, and `.bat` scripts) are included in the repository. Images are pulled automatically from Docker Hub on first run.
