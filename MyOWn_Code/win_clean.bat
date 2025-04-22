@echo off
:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit /b
)

:: Your batch script commands go here
echo Running with administrator privileges...

:: Batch Script to Clear Temp, Cache, and Other Junk Files
echo Cleaning up your system... Please wait.
echo.

:: Clear Temp Files
echo Deleting Temp files...
del /s /q %temp%\* >nul 2>&1
del /s /q C:\Windows\Temp\* >nul 2>&1

:: Clear DNS Cache
echo Clearing DNS cache...
ipconfig /flushdns >nul

:: Clear Windows Update Leftovers
echo Cleaning up Windows Update leftovers...
del /f /s /q %windir%\SoftwareDistribution\Download\* >nul 2>&1

:: Clear Prefetch Files
echo Deleting Prefetch files...
del /s /q C:\Windows\Prefetch\* >nul 2>&1

:: Empty Recycle Bin
echo Emptying Recycle Bin...
rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1

:: Delete System Hibernation File
echo Disabling hibernation to delete hibernation file...
powercfg -h off

:: Clear Windows Store Cache Silently
echo Clearing Windows Store cache silently...
start /wait wsreset.exe >nul 2>&1
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

:: Delete Logs and Crash Dumps
echo Deleting logs and crash dumps...
del /s /q C:\Windows\System32\LogFiles\* >nul 2>&1
del /s /q C:\Windows\Minidump\* >nul 2>&1

:: Clean Browser Cache (for Edge)
echo Clearing Edge browser cache...
rd /s /q %localappdata%\Microsoft\Edge\User Data\Default\Cache >nul 2>&1

:: Final Message
echo.
echo Cleanup complete! Your system is sparkling now. :)
pause