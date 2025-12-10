from __future__ import annotations

from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator


def print_hello() -> None:
    print("Hello from the Airflow PoC!")


def print_summary() -> None:
    print("This DAG demonstrates a lightweight Airflow deployment for evaluation.")


default_args = {
    "start_date": datetime(2024, 1, 1),
    "catchup": False,
    "tags": ["poc"],
}

with DAG(
    dag_id="airflow_poc_demo",
    schedule="@daily",
    default_args=default_args,
) as dag:
    start = EmptyOperator(task_id="start")

    hello = PythonOperator(
        task_id="say_hello",
        python_callable=print_hello,
    )

    summary = PythonOperator(
        task_id="print_summary",
        python_callable=print_summary,
    )

    end = EmptyOperator(task_id="end")

    start >> hello >> summary >> end
