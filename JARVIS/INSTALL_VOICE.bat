@echo off
cd /d "%~dp0"
if not exist .venv\Scripts\python.exe (
  echo Run SETUP.bat first.
  pause
  exit /b 1
)
if not exist data\temp mkdir data\temp
set "TEMP=%CD%\data\temp"
set "TMP=%CD%\data\temp"
.venv\Scripts\python.exe -m pip install --no-cache-dir -r requirements-voice.txt
if errorlevel 1 goto failed
.venv\Scripts\python.exe -m core.voice_setup
if errorlevel 1 goto failed
echo Offline voice installed. Restart JARVIS or apply Auto in Voice settings.
pause
exit /b 0
:failed
echo Installation did not finish. Copy the error above.
pause
exit /b 1
