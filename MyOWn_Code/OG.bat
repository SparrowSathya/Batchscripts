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
echo **************************************** 
echo *            SYSTEM CLEANUP            * 
echo **************************************** 
echo Cleanup started at %date% %time%         
echo **************************************** 

:: Terminate Unnecessary Processes
echo [+] Terminating unnecessary processes... 

:: Terminate Edge Process
echo [>] Checking Edge processes...           
tasklist /fi "imagename eq msedge.exe" | find /i "msedge.exe" >nul
if %errorlevel% neq 0 (
    echo [!] Edge is not running. Skipping termination... 
) else (
    taskkill /f /im msedge.exe >nul 2>&1 && echo [+] Edge processes terminated successfully  || echo [!] Failed to terminate Edge processes 
)

:: Terminate Firefox Process
echo [>] Checking Firefox processes...        
tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" >nul
if %errorlevel% neq 0 (
    echo [!] Firefox is not running. Skipping termination... 
) else (
    taskkill /f /im firefox.exe >nul 2>&1 && echo [+] Firefox processes terminated successfully  || echo [!] Failed to terminate Firefox processes 
)

:: Clear Temp Files
echo [>] Checking Temp files directory...     
if exist "%temp%\*" (
    echo [+] Deleting Temp files...           
    del /s /q %temp%\* >nul 2>&1 && echo [+] Temp files cleaned successfully  || echo [!] Failed to clean Temp files 
) else (
    echo [!] Temp directory is empty. Skipping cleanup... 
)

if exist "C:\Windows\Temp\*" (
    echo [+] Deleting Windows Temp files...   
    del /s /q C:\Windows\Temp\* >nul 2>&1 && echo [+] Windows Temp files cleaned successfully  || echo [!] Failed to clean Windows Temp files 
) else (
    echo [!] Windows Temp directory is empty. Skipping cleanup... 
)

:: Clear DNS Cache
echo [>] Clearing DNS cache...                
ipconfig /flushdns >nul && echo [+] DNS cache cleared successfully  || echo [!] Failed to clear DNS cache 

:: Clear Windows Update Leftovers
echo [>] Checking Windows Update leftovers... 
if exist "%windir%\SoftwareDistribution\Download\*" (
    echo [+] Deleting Windows Update leftovers... 
    del /f /s /q %windir%\SoftwareDistribution\Download\* >nul 2>&1 && echo [+] Windows Update leftovers cleaned successfully  || echo [!] Failed to clean Windows Update leftovers 
) else (
    echo [!] Windows Update leftovers directory is empty. Skipping cleanup... 
)

:: Clear Prefetch Files
echo [>] Checking Prefetch directory...       
if exist "C:\Windows\Prefetch\*" (
    echo [+] Deleting Prefetch files...       
    del /s /q C:\Windows\Prefetch\* >nul 2>&1 && echo [+] Prefetch files cleaned successfully  || echo [!] Failed to clean Prefetch files 
) else (
    echo [!] Prefetch directory is empty. Skipping cleanup... 
)

:: Empty Recycle Bin
echo [>] Checking Recycle Bin...              
if exist "%systemdrive%\$Recycle.Bin" (
    echo [+] Emptying Recycle Bin...          
    rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1 && echo [+] Recycle Bin emptied successfully  || echo [!] Failed to empty Recycle Bin 
) else (
    echo [!] Recycle Bin is empty. Skipping cleanup... 
)

:: Delete System Hibernation File
echo [>] Disabling hibernation...             
powercfg -h off && echo [+] Hibernation file deleted successfully  || echo [!] Failed to delete hibernation file 

:: Clear Windows Store Cache Silently
echo [>] Clearing Windows Store cache...      
start /wait wsreset.exe >nul 2>&1 && echo [+] Windows Store cache cleared successfully  || echo [!] Failed to clear Windows Store cache 
taskkill /f /im ApplicationFrameHost.exe >nul 2>&1

:: Delete Logs and Crash Dumps
echo [>] Checking Logs and Dumps directories... 
if exist "C:\Windows\System32\LogFiles\*" (
    echo [+] Deleting system logs...          
    del /s /q C:\Windows\System32\LogFiles\* >nul 2>&1 && echo [+] System logs deleted successfully  || echo [!] Failed to delete system logs 
) else (
    echo [!] System logs directory is empty. Skipping cleanup... 
)

if exist "C:\Windows\Minidump\*" (
    echo [+] Deleting crash dumps...          
    del /s /q C:\Windows\Minidump\* >nul 2>&1 && echo [+] Crash dumps deleted successfully  || echo [!] Failed to delete crash dumps 
) else (
    echo [!] Crash dumps directory is empty. Skipping cleanup... 
)

:: Clear Edge Browser Cache
echo [>] Checking Edge browser cache...       
if exist "%localappdata%\Microsoft\Edge\User Data\Default\Cache" (
    echo [+] Clearing Edge browser cache...   
    rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1 && echo [+] Edge browser cache cleared successfully  || echo [!] Failed to clear Edge browser cache 
) else (
    echo [!] Edge cache folder does not exist. Skipping cleanup... 
)

:: Clear Firefox Browser Cache
echo [>] Clearing Firefox browser cache...    
for /d %%P in ("%localappdata%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%P\cache2" (
        rd /s /q "%%P\cache2" >nul 2>&1 && echo [+] Firefox cache cleared successfully  || echo [!] Failed to clear Firefox cache for profile %%P 
    ) else (
        echo [!] Firefox cache folder does not exist for profile %%P. Skipping cleanup... 
    )
)

:: Final Log Entry
echo **************************************** 
echo [+] Cleanup finished at %date% %time%    
echo **************************************** 

pause