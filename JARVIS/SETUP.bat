@echo off
cd /d "%~dp0"
if exist .venv\Scripts\python.exe goto install
py -3.13 -m venv .venv
if not errorlevel 1 goto install
py -3.12 -m venv .venv
if not errorlevel 1 goto install
echo Python 3.12 or 3.13 is required. Existing environments are reused.
pause
exit /b 1
:install
if not exist data\temp mkdir data\temp
set "TEMP=%CD%\data\temp"
set "TMP=%CD%\data\temp"
.venv\Scripts\python.exe -m pip install --no-cache-dir -r requirements.txt
if errorlevel 1 goto failed
.venv\Scripts\python.exe -m core.install
if errorlevel 1 goto failed
echo Setup completed. Open START.bat.
pause
exit /b 0
:failed
echo Setup did not finish. Copy the error above for troubleshooting.
pause
exit /b 1
