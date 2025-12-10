@echo off
setlocal enabledelayedexpansion

pushd %~dp0\..

set "CONTAINER_ENGINE="
where docker >nul 2>nul && set "CONTAINER_ENGINE=docker"
if not defined CONTAINER_ENGINE (
  where podman >nul 2>nul && set "CONTAINER_ENGINE=podman"
)

if not defined CONTAINER_ENGINE (
  echo Neither Docker nor Podman was found on PATH. Please install one of them and retry.
  exit /b 1
)

echo Using %CONTAINER_ENGINE% compose to start the Airflow PoC environment...
set "COMPOSE_CMD=%CONTAINER_ENGINE% compose"

:: ensure UID is set for Linux hosts running via WSL or similar
if not defined AIRFLOW_UID (
  for /f "tokens=*" %%i in ('%CONTAINER_ENGINE% run --rm --entrypoint sh apache/airflow:3.1.4 -c "id -u"') do set "AIRFLOW_UID=%%i"
)

%COMPOSE_CMD% pull
if errorlevel 1 (
  echo Failed to pull images.
  exit /b 1
)

%COMPOSE_CMD% up airflow-init
if errorlevel 1 (
  echo Initialization failed.
  exit /b 1
)

%COMPOSE_CMD% up -d airflow-apiserver airflow-scheduler airflow-worker airflow-triggerer airflow-dag-processor redis postgres
if errorlevel 1 (
  echo Services failed to start.
  exit /b 1
)

echo Airflow PoC is starting. API/UI should be available at http://localhost:8080 once healthy.
popd
endlocal
