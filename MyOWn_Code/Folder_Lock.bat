@echo off
title Folder Lock
set "lock_folder=Private"
set "password=1730"

:main
cls
echo =======================================
echo          FOLDER LOCK SYSTEM
echo =======================================
echo 1. Lock the folder
echo 2. Unlock the folder
echo 3. Exit
echo =======================================
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto lock
if "%choice%"=="2" goto unlock
if "%choice%"=="3" goto exit

echo Invalid choice! Please try again.
pause
goto main

:lock
if not exist "%lock_folder%" (
    mkdir "%lock_folder%"
)
attrib +h +s "%lock_folder%"
echo Folder "%lock_folder%" is now locked.
pause
goto main

:unlock
if not exist "%lock_folder%" (
    echo Folder "%lock_folder%" does not exist or is already unlocked.
    pause
    goto main
)
set /p input_password="Enter the password to unlock: "
if "%input_password%"=="%password%" (
    attrib -h -s "%lock_folder%"
    echo Folder "%lock_folder%" is now unlocked.
) else (
    echo Incorrect password! Access denied.
)
pause
goto main

:exit
echo Exiting Folder Lock. Goodbye!
pause
exit
