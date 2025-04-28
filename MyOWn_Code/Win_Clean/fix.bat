@echo off
setlocal

rem Define the log file
set "LOGFILE=%systemdrive%\ComprehensiveCleanupLog.txt"

rem Use the helper subroutine to log each line
call :LogMsg "****************************************"
call :LogMsg "*            SYSTEM CLEANUP            *"
call :LogMsg "****************************************"
call :LogMsg "Cleanup started at %date% %time%"
call :LogMsg "****************************************"

rem Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    call :LogMsg "[!] Requesting administrator privileges..."
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /B
)

rem Terminate Unnecessary Processes
call :LogMsg "[+] Terminating unnecessary processes..."

rem Terminate Edge Process
call :LogMsg "[>] Checking Edge processes..."
tasklist /fi "imagename eq msedge.exe" | find /i "msedge.exe" >nul
if %errorlevel% neq 0 (
    call :LogMsg "[!] Edge is not running. Skipping termination..."
) else (
    taskkill /f /im msedge.exe >nul 2>&1 && call :LogMsg "[+] Edge processes terminated successfully" || call :LogMsg "[!] Failed to terminate Edge processes"
)

rem Terminate Firefox Process
call :LogMsg "[>] Checking Firefox processes..."
tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" >nul
if %errorlevel% neq 0 (
    call :LogMsg "[!] Firefox is not running. Skipping termination..."
) else (
    taskkill /f /im firefox.exe >nul 2>&1 && call :LogMsg "[+] Firefox processes terminated successfully" || call :LogMsg "[!] Failed to terminate Firefox processes"
)

rem Clear Temp Files
call :LogMsg "[>] Checking Temp files directory..."
if exist "%temp%\*" (
    call :LogMsg "[+] Deleting Temp files..."
    del /s /q %temp%\* >nul 2>&1 && call :LogMsg "[+] Temp files cleaned successfully" || call :LogMsg "[!] Failed to clean Temp files"
) else (
    call :LogMsg "[!] Temp directory is empty. Skipping cleanup..."
)

if exist "C:\Windows\Temp\*" (
    call :LogMsg "[+] Deleting Windows Temp files..."
    del /s /q C:\Windows\Temp\* >nul 2>&1 && call :LogMsg "[+] Windows Temp files cleaned successfully" || call :LogMsg "[!] Failed to clean Windows Temp files"
) else (
    call :LogMsg "[!] Windows Temp directory is empty. Skipping cleanup..."
)

rem Clear DNS Cache
call :LogMsg "[>] Clearing DNS cache..."
ipconfig /flushdns >nul && call :LogMsg "[+] DNS cache cleared successfully" || call :LogMsg "[!] Failed to clear DNS cache"

rem Clear Windows Update Leftovers
call :LogMsg "[>] Checking Windows Update leftovers..."
if exist "%windir%\SoftwareDistribution\Download\*" (
    call :LogMsg "[+] Deleting Windows Update leftovers..."
    del /f /s /q %windir%\SoftwareDistribution\Download\* >nul 2>&1 && call :LogMsg "[+] Windows Update leftovers cleaned successfully" || call :LogMsg "[!] Failed to clean Windows Update leftovers"
) else (
    call :LogMsg "[!] Windows Update leftovers directory is empty. Skipping cleanup..."
)

rem Clear Prefetch Files
call :LogMsg "[>] Checking Prefetch directory..."
if exist "C:\Windows\Prefetch\*" (
    call :LogMsg "[+] Deleting Prefetch files..."
    del /s /q C:\Windows\Prefetch\* >nul 2>&1 && call :LogMsg "[+] Prefetch files cleaned successfully" || call :LogMsg "[!] Failed to clean Prefetch files"
) else (
    call :LogMsg "[!] Prefetch directory is empty. Skipping cleanup..."
)

rem Empty Recycle Bin
call :LogMsg "[>] Checking Recycle Bin..."
if exist "%systemdrive%\$Recycle.Bin" (
    call :LogMsg "[+] Emptying Recycle Bin..."
    rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1 && call :LogMsg "[+] Recycle Bin emptied successfully" || call :LogMsg "[!] Failed to empty Recycle Bin"
) else (
    call :LogMsg "[!] Recycle Bin is empty. Skipping cleanup..."
)

rem Delete System Hibernation File
call :LogMsg "[>] Disabling hibernation..."
powercfg -h off && call :LogMsg "[+] Hibernation file deleted successfully" || call :LogMsg "[!] Failed to delete hibernation file"

rem Clear Windows Store Cache Silently
call :LogMsg "[>] Clearing Windows Store cache..."
start /wait wsreset.exe >nul && call :LogMsg "[+] Windows Store cache cleared successfully" || call :LogMsg "[!] Failed to clear Windows Store cache"
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

rem Delete Logs and Crash Dumps
call :LogMsg "[>] Checking Logs and Dumps directories..."
if exist "C:\Windows\System32\LogFiles\*" (
    call :LogMsg "[+] Deleting system logs..."
    del /s /q C:\Windows\System32\LogFiles\* >nul 2>&1 && call :LogMsg "[+] System logs deleted successfully" || call :LogMsg "[!] Failed to delete system logs"
) else (
    call :LogMsg "[!] System logs directory is empty. Skipping cleanup..."
)

if exist "C:\Windows\Minidump\*" (
    call :LogMsg "[+] Deleting crash dumps..."
    del /s /q C:\Windows\Minidump\* >nul 2>&1 && call :LogMsg "[+] Crash dumps deleted successfully" || call :LogMsg "[!] Failed to delete crash dumps"
) else (
    call :LogMsg "[!] Crash dumps directory is empty. Skipping cleanup..."
)

rem Clear Edge Browser Cache
call :LogMsg "[>] Checking Edge browser cache..."
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    call :LogMsg "[+] Clearing Edge browser cache..."
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && call :LogMsg "[+] Edge browser cache cleared successfully" || call :LogMsg "[!] Failed to clear Edge browser cache"
) else (
    call :LogMsg "[!] Edge cache folder does not exist. Skipping cleanup..."
)

rem Clear Firefox Browser Cache
call :LogMsg "[>] Clearing Firefox browser cache..."
for /d %%P in ("%localappdata%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" (
        rd /s /q "%%P\cache2" >nul 2>&1 && call :LogMsg "[+] Firefox cache cleared successfully" || call :LogMsg "[!] Failed to clear Firefox cache for profile %%P"
    ) else (
        call :LogMsg "[!] Firefox cache folder does not exist for profile %%P. Skipping cleanup..."
    )
)

rem Final Log Entry
call :LogMsg "****************************************"
call :LogMsg "[+] Cleanup finished at %date% %time%"
call :LogMsg "****************************************"

exit /B

:LogMsg
rem %~1 removes any surrounding quotes from the parameter
echo %~1
echo %~1 >> "%LOGFILE%"
exit /B