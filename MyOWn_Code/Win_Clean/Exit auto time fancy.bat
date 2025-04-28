@echo off
:: Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)
:: Final Display
echo.
echo ****************************************
echo [+] Cleanup finished at %date% %time%
echo ****************************************
echo.

echo Exiting in:
for /l %%i in (5,-1,1) do (
    set /p="%%i... " <nul
    timeout /t 1 /nobreak >nul
)
echo.
echo.
:: Fancy slow typing effect for "Goodbye! 👋"
setlocal enabledelayedexpansion
set "message=Goodbye! "
for /l %%i in (0,1,15) do (
    set "letter=!message:~%%i,1!"
    if defined letter (
        set /p="!letter!" <nul
        timeout /t 1 >nul
    )
)
echo.
timeout /t 2 /nobreak >nul
exit /b 0
:: End of Script
