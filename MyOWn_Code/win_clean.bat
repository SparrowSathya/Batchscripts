@echo off
:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)

:: Define log file
set logFile=%systemdrive%\MyCleanupLog.txt

:: Start logging
echo ============================= >> %logFile%
echo Cleanup started at %date% %time% >> %logFile%
echo ============================= >> %logFile%

:: Batch Script to Clear Temp, Cache, and Other Junk Files
echo Cleaning up your system... Please wait.
echo.

:: Clear Temp Files
echo Deleting Temp files... >> %logFile%
del /s /q %temp%\* >nul 2>&1 && echo Temp files cleaned successfully >> %logFile% || echo Failed to clean Temp files >> %logFile%
del /s /q C:\Windows\Temp\* >nul 2>&1 && echo Windows Temp files cleaned successfully >> %logFile% || echo Failed to clean Windows Temp files >> %logFile%

:: Clear DNS Cache
echo Clearing DNS cache... >> %logFile%
ipconfig /flushdns >nul && echo DNS cache cleared successfully >> %logFile% || echo Failed to clear DNS cache >> %logFile%

:: Clear Windows Update Leftovers
echo Cleaning up Windows Update leftovers... >> %logFile%
del /f /s /q %windir%\SoftwareDistribution\Download\* >nul 2>&1 && echo Windows Update leftovers cleaned successfully >> %logFile% || echo Failed to clean Windows Update leftovers >> %logFile%

:: Clear Prefetch Files
echo Deleting Prefetch files... >> %logFile%
del /s /q C:\Windows\Prefetch\* >nul 2>&1 && echo Prefetch files cleaned successfully >> %logFile% || echo Failed to clean Prefetch files >> %logFile%

:: Empty Recycle Bin
echo Emptying Recycle Bin... >> %logFile%
rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1 && echo Recycle Bin emptied successfully >> %logFile% || echo Failed to empty Recycle Bin >> %logFile%

:: Delete System Hibernation File
echo Disabling hibernation to delete hibernation file... >> %logFile%
powercfg -h off && echo Hibernation file deleted successfully >> %logFile% || echo Failed to delete hibernation file >> %logFile%

:: Clear Windows Store Cache Silently
echo Clearing Windows Store cache silently... >> %logFile%
start /wait wsreset.exe >nul 2>&1 && echo Windows Store cache cleared successfully >> %logFile% || echo Failed to clear Windows Store cache >> %logFile%
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

:: Delete Logs and Crash Dumps
echo Deleting logs and crash dumps... >> %logFile%
del /s /q C:\Windows\System32\LogFiles\* >nul 2>&1 && echo System logs deleted successfully >> %logFile% || echo Failed to delete system logs >> %logFile%
del /s /q C:\Windows\Minidump\* >nul 2>&1 && echo Crash dumps deleted successfully >> %logFile% || echo Failed to delete crash dumps >> %logFile%

:: Clear Edge Browser Cache
echo Clearing Edge browser cache...
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && echo Edge browser cache cleared successfully >> %logFile% || echo Failed to clear Edge browser cache >> %logFile%
) else (
    echo Edge cache folder does not exist. >> %logFile%
)

:: Clear Firefox Browser Cache
echo Clearing Firefox browser cache...
for /d %%P in ("%localappdata%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" (
        rd /s /q "%%P\cache2" >nul 2>&1 && echo Firefox browser cache cleared successfully >> %logFile% || echo Failed to clear Firefox browser cache >> %logFile%
    ) else (
        echo Firefox cache folder does not exist in profile %%P. >> %logFile%
    )
)

:: Final Message
echo Cleanup complete! Your system is sparkling now. :)
echo Cleanup finished at %date% %time% >> %logFile%
echo ============================= >> %logFile%

pause