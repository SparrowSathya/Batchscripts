@echo off
:: Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)

:: Start Display
echo ****************************************
echo *            SYSTEM CLEANUP            *
echo ****************************************
echo Cleanup started at %date% %time%
echo ****************************************
echo.

:: 1. Terminate Unnecessary Processes
echo [1] Terminating unnecessary processes...

:: 1.1 Terminate Edge Process
echo [1.1] Checking Edge processes...
tasklist /fi "imagename eq msedge.exe" | find /i "msedge.exe" >nul
if %errorlevel% neq 0 (
    echo [!] Edge is not running. Skipping termination...
) else (
    taskkill /f /im msedge.exe >nul 2>&1 && echo [+] Edge processes terminated successfully || echo [!] Failed to terminate Edge processes
)

:: 1.2 Terminate Firefox Process
echo [1.2] Checking Firefox processes...
tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" >nul
if %errorlevel% neq 0 (
    echo [!] Firefox is not running. Skipping termination...
) else (
    taskkill /f /im firefox.exe >nul 2>&1 && echo [+] Firefox processes terminated successfully || echo [!] Failed to terminate Firefox processes
)

:: 2. Clear Temp Files
echo [2] Checking Temp files directory...
if exist "%temp%\*" (
    echo [2.1] Deleting Temp files...
    del /s /q "%temp%\*" >nul 2>&1 && echo [+] Temp files cleaned successfully || echo [!] Failed to clean Temp files
) else (
    echo [!] Temp directory is empty. Skipping cleanup...
)

if exist "C:\Windows\Temp\*" (
    echo [2.2] Deleting Windows Temp files...
    del /s /q "C:\Windows\Temp\*" >nul 2>&1 && echo [+] Windows Temp files cleaned successfully || echo [!] Failed to clean Windows Temp files
) else (
    echo [!] Windows Temp directory is empty. Skipping cleanup...
)

:: 3. Clear DNS Cache
echo [3] Clearing DNS cache...
ipconfig /flushdns >nul && echo [+] DNS cache cleared successfully || echo [!] Failed to clear DNS cache

:: 4. Clear Windows Update Leftovers
echo [4] Checking Windows Update leftovers...
if exist "%windir%\SoftwareDistribution\Download\*" (
    echo [4.1] Deleting Windows Update leftovers...
    del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1 && echo [+] Windows Update leftovers cleaned successfully || echo [!] Failed to clean Windows Update leftovers
) else (
    echo [!] Windows Update leftovers directory is empty. Skipping cleanup...
)

:: 5. Clear Prefetch Files
echo [5] Checking Prefetch directory...
if exist "C:\Windows\Prefetch\*" (
    echo [5.1] Deleting Prefetch files...
    del /s /q "C:\Windows\Prefetch\*" >nul 2>&1 && echo [+] Prefetch files cleaned successfully || echo [!] Failed to clean Prefetch files
) else (
    echo [!] Prefetch directory is empty. Skipping cleanup...
)

:: 6. Empty Recycle Bin
echo [6] Checking Recycle Bin...
if exist "%systemdrive%\$Recycle.Bin" (
    echo [6.1] Emptying Recycle Bin...
    rd /s /q "%systemdrive%\$Recycle.Bin" >nul 2>&1 && echo [+] Recycle Bin emptied successfully || echo [!] Failed to empty Recycle Bin
) else (
    echo [!] Recycle Bin is empty. Skipping cleanup...
)

:: 7. Delete System Hibernation File
echo [7] Disabling hibernation...
powercfg -h off && echo [+] Hibernation file deleted successfully || echo [!] Failed to delete hibernation file

:: 8. Clear Windows Store Cache
echo [8] Clearing Windows Store cache...
start /wait wsreset.exe >nul 2>&1 && echo [+] Windows Store cache cleared successfully || echo [!] Failed to clear Windows Store cache
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

:: 9. Delete Logs and Crash Dumps
echo [9] Checking Logs and Dumps directories...
if exist "C:\Windows\System32\LogFiles\*" (
    echo [9.1] Deleting system logs...
    del /s /q "C:\Windows\System32\LogFiles\*" >nul 2>&1 && echo [+] System logs deleted successfully || echo [!] Failed to delete system logs
) else (
    echo [!] System logs directory is empty. Skipping cleanup...
)

if exist "C:\Windows\Minidump\*" (
    echo [9.2] Deleting crash dumps...
    del /s /q "C:\Windows\Minidump\*" >nul 2>&1 && echo [+] Crash dumps deleted successfully || echo [!] Failed to delete crash dumps
) else (
    echo [!] Crash dumps directory is empty. Skipping cleanup...
)

:: 10. Clear Edge Browser Cache
echo [10] Checking Edge browser cache...
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    echo [10.1] Clearing Edge browser cache...
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && echo [+] Edge browser cache cleared successfully || echo [!] Failed to clear Edge browser cache
) else (
    echo [!] Edge cache folder does not exist. Skipping cleanup...
)

:: 11. Clear Firefox Browser Cache
echo [11] Clearing Firefox browser cache...
for /d %%P in ("%localappdata%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" (
        echo [11.1] Clearing Firefox cache for profile %%P...
        rd /s /q "%%P\cache2" >nul 2>&1 && echo [+] Firefox cache cleared successfully || echo [!] Failed to clear Firefox cache for profile %%P
    ) else (
        echo [!] Firefox cache folder does not exist for profile %%P. Skipping cleanup...
    )
)

:: Final Display
echo.
echo ****************************************
echo [+] Cleanup finished at %date% %time%
echo ****************************************
echo Cleanup complete! Your system is sparkling now. :)
echo ****************************************
echo.
:: echo [!] Press any key to exit...
:: pause >nul
timeout /t 5 /nobreak > nul
exit /b 0
:: End of Script
