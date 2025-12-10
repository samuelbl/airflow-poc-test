# Airflow Proof of Concept

## Proof of Concept Project
- Minimal Apache Airflow 3.1.4 environment using Docker/Podman compose.
- Containers: Airflow API server, scheduler, Celery worker, triggerer, DAG processor, Redis, PostgreSQL.
- Windows-friendly automation via `scripts/start-airflow-poc.bat` and `scripts/cleanup-airflow-poc.bat`.
- Sample DAG (`dags/example_poc_dag.py`) using modern decorators to validate task execution.

## What this PoC shows
- Bootstraps Airflow 3.1.4 with CeleryExecutor, PostgreSQL metadata database, and Redis broker using the official compose template.
- Seeds an admin user (`airflow` / `airflow`) and default connections for immediate login.
- Demonstrates DAG discovery with a decorator-based example workflow.
- Runs with either Docker or Podman using the same compose definition.

## Files provided
- `docker-compose.yml` — Official compose stack for Airflow, PostgreSQL, and Redis (CeleryExecutor).
- `.env` — Default environment overrides (UID, project dir, Airflow image).
- `dags/example_poc_dag.py` — Example DAG that prints PoC markers via decorators.
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
   - Start the API server, scheduler, worker, triggerer, DAG processor, Redis, and PostgreSQL containers.

### Verify
- Airflow API/UI: `http://localhost:8080` (username `airflow`, password `airflow`).
- Confirm the `airflow_poc_demo` DAG appears and can be triggered manually.

## Ports & Containers
| Component | Container Name | Host:Container | Notes |
| --- | --- | --- | --- |
| PostgreSQL | `airflow-poc-test-postgres-1` | `5432:5432` (internal unless published) | DB name/user/password: `airflow` |
| Redis | `airflow-poc-test-redis-1` | internal | Broker for Airflow background tasks |
| Airflow API server | `airflow-poc-test-airflow-apiserver-1` | `8080:8080` | Admin login: `airflow` / `airflow` |
| Airflow Scheduler | `airflow-poc-test-airflow-scheduler-1` | internal | Executes DAG tasks |
| Airflow Worker | `airflow-poc-test-airflow-worker-1` | internal | Celery worker for task execution |
| Airflow Triggerer | `airflow-poc-test-airflow-triggerer-1` | internal | Handles deferrable operator triggers |
| Airflow DAG Processor | `airflow-poc-test-airflow-dag-processor-1` | internal | Parses and processes DAGs |

> Container names may include a project prefix depending on compose version; adjust accordingly when inspecting resources.

## Cleanup
Run `scripts\cleanup-airflow-poc.bat` from the repository root to remove:
- Containers and networks created by the compose stack.
- Volumes (`postgres-db-volume`) and mounted log/config directories.
- Local images pulled for the PoC (via `--rmi local`).

## Downloads
All required files (`docker-compose.yml`, `.env`, `dags/`, and `.bat` scripts) are included in the repository. Images are pulled automatically from Docker Hub on first run.
