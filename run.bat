@echo off
rem Usage:  run.bat                      run the sample messages through the graph
rem         run.bat test                 run the unit tests
rem         run.bat msg "para 650 x 4"   run a single message
rem         run.bat graph                print the graph as a Mermaid diagram
rem The first run creates a .venv folder and installs LangGraph into it.
setlocal
cd /d "%~dp0"

set PY=python
where python >nul 2>nul || set PY=py -3
%PY% --version >nul 2>nul
if errorlevel 1 (
  echo Python 3.10 or newer is required. Install it from https://www.python.org/downloads/
  exit /b 1
)

if not exist .venv (
  echo Creating .venv and installing requirements, first run only...
  %PY% -m venv .venv
  if errorlevel 1 exit /b 1
  .venv\Scripts\python -m pip install --quiet --upgrade pip
  .venv\Scripts\python -m pip install --quiet -r requirements.txt
  if errorlevel 1 exit /b 1
)
set VPY=.venv\Scripts\python

if "%1"=="test" (
  %VPY% -m unittest discover -s tests -v
  exit /b %errorlevel%
)
if "%1"=="msg" (
  %VPY% -m order_agent run %2
  exit /b %errorlevel%
)
if "%1"=="graph" (
  %VPY% -m order_agent graph
  exit /b %errorlevel%
)
%VPY% -m order_agent demo
exit /b %errorlevel%
