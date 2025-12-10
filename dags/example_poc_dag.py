from __future__ import annotations

from datetime import datetime

from airflow.decorators import dag, task


def _log(message: str) -> None:
    print(message)


def _common_context() -> dict[str, str]:
    return {"project": "airflow-poc"}


@task
def say_hello(context: dict[str, str]) -> None:
    _log(f"Hello from the Airflow PoC! Context: {context}")


@task
def describe_demo() -> None:
    _log("This DAG demonstrates a lightweight Airflow deployment for evaluation.")


@dag(
    dag_id="airflow_poc_demo",
    schedule="@daily",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["poc"],
)
def airflow_poc_demo() -> None:
    context = _common_context()

    say_hello(context)
    describe_demo()


dag = airflow_poc_demo()
