@echo off
:: Enable colors
setlocal enabledelayedexpansion
color 0A

:: Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)

:: Start
echo ****************************************
echo *           SYSTEM CLEANUP             *
echo ****************************************
echo Cleanup started at %date% %time%
echo ****************************************
echo.

:: 1. Terminate Unnecessary Processes
echo [1] Terminating unnecessary processes...

:: Terminate Edge Process
echo [1.1] Checking Edge processes...
tasklist /fi "imagename eq msedge.exe" | find /i "msedge.exe" >nul
if %errorlevel% neq 0 (
    echo [1.1] Edge is not running. Skipping...
) else (
    taskkill /f /im msedge.exe >nul 2>&1 && echo [1.1] Edge processes terminated successfully || echo [1.1] Failed to terminate Edge processes
)

:: Terminate Firefox Process
echo [1.2] Checking Firefox processes...
tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" >nul
if %errorlevel% neq 0 (
    echo [1.2] Firefox is not running. Skipping...
) else (
    taskkill /f /im firefox.exe >nul 2>&1 && echo [1.2] Firefox processes terminated successfully || echo [1.2] Failed to terminate Firefox processes
)

:: 2. Clear Temp Files
echo [2] Clearing Temp files...
if exist "%temp%\*" (
    del /s /q "%temp%\*" >nul 2>&1 && echo [2.1] Temp files cleaned successfully || echo [2.1] Failed to clean Temp files
) else (
    echo [2.1] Temp folder is empty. Skipping...
)

if exist "C:\Windows\Temp\*" (
    del /s /q "C:\Windows\Temp\*" >nul 2>&1 && echo [2.2] Windows Temp files cleaned successfully || echo [2.2] Failed to clean Windows Temp files
) else (
    echo [2.2] Windows Temp folder is empty. Skipping...
)

:: 3. Clear DNS Cache
echo [3] Clearing DNS cache...
ipconfig /flushdns >nul && echo [3.1] DNS cache cleared successfully || echo [3.1] Failed to clear DNS cache

:: 4. Clear Windows Update Leftovers
echo [4] Clearing Windows Update leftovers...
if exist "%windir%\SoftwareDistribution\Download\*" (
    del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1 && echo [4.1] Windows Update leftovers cleaned successfully || echo [4.1] Failed to clean Windows Update leftovers
) else (
    echo [4.1] No Windows Update leftovers found. Skipping...
)

:: 5. Clear Prefetch Files
echo [5] Clearing Prefetch files...
if exist "C:\Windows\Prefetch\*" (
    del /s /q "C:\Windows\Prefetch\*" >nul 2>&1 && echo [5.1] Prefetch files cleaned successfully || echo [5.1] Failed to clean Prefetch files
) else (
    echo [5.1] Prefetch folder is empty. Skipping...
)

:: 6. Empty Recycle Bin
echo [6] Emptying Recycle Bin...
if exist "%systemdrive%\$Recycle.Bin" (
    rd /s /q "%systemdrive%\$Recycle.Bin" >nul 2>&1 && echo [6.1] Recycle Bin emptied successfully || echo [6.1] Failed to empty Recycle Bin
) else (
    echo [6.1] Recycle Bin is empty. Skipping...
)

:: 7. Disable Hibernation
echo [7] Disabling hibernation...
powercfg -h off && echo [7.1] Hibernation file deleted successfully || echo [7.1] Failed to delete hibernation file

:: 8. Clear Windows Store Cache
echo [8] Clearing Windows Store cache...
start /wait wsreset.exe >nul 2>&1 && echo [8.1] Windows Store cache cleared successfully || echo [8.1] Failed to clear Windows Store cache
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

:: 9. Delete Logs and Crash Dumps
echo [9] Deleting system logs and crash dumps...
if exist "C:\Windows\System32\LogFiles\*" (
    del /s /q "C:\Windows\System32\LogFiles\*" >nul 2>&1 && echo [9.1] System logs deleted successfully || echo [9.1] Failed to delete system logs
) else (
    echo [9.1] System logs directory is empty. Skipping...
)

if exist "C:\Windows\Minidump\*" (
    del /s /q "C:\Windows\Minidump\*" >nul 2>&1 && echo [9.2] Crash dumps deleted successfully || echo [9.2] Failed to delete crash dumps
) else (
    echo [9.2] Crash dumps directory is empty. Skipping...
)

:: 10. Clear Browser Caches
echo [10] Clearing Edge browser caches...
:: Edge
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && echo [10.1] Edge browser cache cleared successfully || echo [10.1] Failed to clear Edge cache
) else (
    echo [10.1] No Edge cache found. Skipping...
)
:: 11. Clear Firefox Browser Cache
echo [11] Clearing Firefox browser cache...
:: Firefox
for /d %%P in ("%localappdata%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" (
        rd /s /q "%%P\cache2" >nul 2>&1 && echo [10.2] Firefox cache for profile %%P cleared successfully || echo [10.2] Failed to clear Firefox cache for profile %%P
    ) else (
        echo [11.1] No Firefox cache found for profile %%P. Skipping...
    )
)

:: Final Display
echo.
echo ****************************************
echo [+] Cleanup finished at %date% %time%
echo ****************************************
:: echo.
:: Countdown with dynamic colors
set COUNT=5
:COUNTDOWN

:: Countdown before exiting
echo Exiting in:
for /l %%i in (5,-1,1) do (
    set /p="%%i... " <nul
    timeout /t 1 /nobreak >nul
)

::[ cls
:: echo.
:: echo Exiting in !COUNT! seconds...
:: timeout /t 1 /nobreak >nul
:: set /a COUNT-=1 >nul
:: if !COUNT! geq 0 goto COUNTDOWN]

:: Fancy slow typing "Goodbye! 👋"
:: cls
set "message=Goodbye! 👋"
echo.
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
