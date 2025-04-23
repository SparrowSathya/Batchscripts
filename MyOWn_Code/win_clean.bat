@echo off
:: Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)

:: Define Log File
set logFile=%systemdrive%\ComprehensiveCleanupLog.txt

:: Start Logging
echo **************************************** >> | tee -a  %logFile%
echo *            SYSTEM CLEANUP            * >> %logFile%
echo **************************************** >> %logFile%
echo Cleanup started at %date% %time%         >> %logFile%
echo **************************************** >> %logFile%

:: Terminate Unnecessary Processes
echo [+] Terminating unnecessary processes... >> %logFile%

:: Terminate Edge Process
echo [>] Checking Edge processes...           >> %logFile%
tasklist /fi "imagename eq msedge.exe" | find /i "msedge.exe" >nul
if %errorlevel% neq 0 (
    echo [!] Edge is not running. Skipping termination... >> %logFile%
) else (
    taskkill /f /im msedge.exe >nul 2>&1 && echo [+] Edge processes terminated successfully >> %logFile% || echo [!] Failed to terminate Edge processes >> %logFile%
)

:: Terminate Firefox Process
echo [>] Checking Firefox processes...        >> %logFile%
tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" >nul
if %errorlevel% neq 0 (
    echo [!] Firefox is not running. Skipping termination... >> %logFile%
) else (
    taskkill /f /im firefox.exe >nul 2>&1 && echo [+] Firefox processes terminated successfully >> %logFile% || echo [!] Failed to terminate Firefox processes >> %logFile%
)

:: Clear Temp Files
echo [>] Checking Temp files directory...     >> %logFile%
if exist "%temp%\*" (
    echo [+] Deleting Temp files...           >> %logFile%
    del /s /q %temp%\* >nul 2>&1 && echo [+] Temp files cleaned successfully >> %logFile% || echo [!] Failed to clean Temp files >> %logFile%
) else (
    echo [!] Temp directory is empty. Skipping cleanup... >> %logFile%
)

if exist "C:\Windows\Temp\*" (
    echo [+] Deleting Windows Temp files...   >> %logFile%
    del /s /q C:\Windows\Temp\* >nul 2>&1 && echo [+] Windows Temp files cleaned successfully >> %logFile% || echo [!] Failed to clean Windows Temp files >> %logFile%
) else (
    echo [!] Windows Temp directory is empty. Skipping cleanup... >> %logFile%
)

:: Clear DNS Cache
echo [>] Clearing DNS cache...                >> %logFile%
ipconfig /flushdns >nul && echo [+] DNS cache cleared successfully >> %logFile% || echo [!] Failed to clear DNS cache >> %logFile%

:: Clear Windows Update Leftovers
echo [>] Checking Windows Update leftovers... >> %logFile%
if exist "%windir%\SoftwareDistribution\Download\*" (
    echo [+] Deleting Windows Update leftovers... >> %logFile%
    del /f /s /q %windir%\SoftwareDistribution\Download\* >nul 2>&1 && echo [+] Windows Update leftovers cleaned successfully >> %logFile% || echo [!] Failed to clean Windows Update leftovers >> %logFile%
) else (
    echo [!] Windows Update leftovers directory is empty. Skipping cleanup... >> %logFile%
)

:: Clear Prefetch Files
echo [>] Checking Prefetch directory...       >> %logFile%
if exist "C:\Windows\Prefetch\*" (
    echo [+] Deleting Prefetch files...       >> %logFile%
    del /s /q C:\Windows\Prefetch\* >nul 2>&1 && echo [+] Prefetch files cleaned successfully >> %logFile% || echo [!] Failed to clean Prefetch files >> %logFile%
) else (
    echo [!] Prefetch directory is empty. Skipping cleanup... >> %logFile%
)

:: Empty Recycle Bin
echo [>] Checking Recycle Bin...              >> %logFile%
if exist "%systemdrive%\$Recycle.Bin" (
    echo [+] Emptying Recycle Bin...          >> %logFile%
    rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1 && echo [+] Recycle Bin emptied successfully >> %logFile% || echo [!] Failed to empty Recycle Bin >> %logFile%
) else (
    echo [!] Recycle Bin is empty. Skipping cleanup... >> %logFile%
)

:: Delete System Hibernation File
echo [>] Disabling hibernation...             >> %logFile%
powercfg -h off && echo [+] Hibernation file deleted successfully >> %logFile% || echo [!] Failed to delete hibernation file >> %logFile%

:: Clear Windows Store Cache Silently
echo [>] Clearing Windows Store cache...      >> %logFile%
start /wait wsreset.exe >nul 2>&1 && echo [+] Windows Store cache cleared successfully >> %logFile% || echo [!] Failed to clear Windows Store cache >> %logFile%
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

:: Delete Logs and Crash Dumps
echo [>] Checking Logs and Dumps directories... >> %logFile%
if exist "C:\Windows\System32\LogFiles\*" (
    echo [+] Deleting system logs...          >> %logFile%
    del /s /q C:\Windows\System32\LogFiles\* >nul 2>&1 && echo [+] System logs deleted successfully >> %logFile% || echo [!] Failed to delete system logs >> %logFile%
) else (
    echo [!] System logs directory is empty. Skipping cleanup... >> %logFile%
)

if exist "C:\Windows\Minidump\*" (
    echo [+] Deleting crash dumps...          >> %logFile%
    del /s /q C:\Windows\Minidump\* >nul 2>&1 && echo [+] Crash dumps deleted successfully >> %logFile% || echo [!] Failed to delete crash dumps >> %logFile%
) else (
    echo [!] Crash dumps directory is empty. Skipping cleanup... >> %logFile%
)

:: Clear Edge Browser Cache
echo [>] Checking Edge browser cache...       >> %logFile%
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    echo [+] Clearing Edge browser cache...   >> %logFile%
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && echo [+] Edge browser cache cleared successfully >> %logFile% || echo [!] Failed to clear Edge browser cache >> %logFile%
) else (
    echo [!] Edge cache folder does not exist. Skipping cleanup... >> %logFile%
)

:: Clear Firefox Browser Cache
echo [>] Clearing Firefox browser cache...    >> %logFile%
for /d %%P in ("%localappdata%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" (
        rd /s /q "%%P\cache2" >nul 2>&1 && echo [+] Firefox cache cleared successfully >> %logFile% || echo [!] Failed to clear Firefox cache for profile %%P >> %logFile%
    ) else (
        echo [!] Firefox cache folder does not exist for profile %%P. Skipping cleanup... >> %logFile%
    )
)
echo Cleanup complete! Your system is sparkling now. :)
:: Final Log Entry
echo **************************************** >> %logFile%
echo [+] Cleanup finished at %date% %time%    >> %logFile%
echo **************************************** >> %logFile%

pause
