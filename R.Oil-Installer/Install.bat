@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-R.Oil.ps1"
if errorlevel 1 (
  echo.
  echo Installation failed. See the error message above.
  pause
  exit /b 1
)
endlocal
