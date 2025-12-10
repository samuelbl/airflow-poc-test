@echo off
setlocal

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

set "COMPOSE_CMD=%CONTAINER_ENGINE% compose"

echo Stopping and removing Airflow PoC resources...
%COMPOSE_CMD% down -v --remove-orphans --rmi local

popd
endlocal
