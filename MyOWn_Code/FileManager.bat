@echo off
title File Manager by Sathya !
:menu
cls
echo ================================
echo           FILE MANAGER          
echo ================================
echo 1. Create a File
echo 2. Delete a File
echo 3. Rename a File
echo 4. Copy a File
echo 5. Move a File
echo 6. Create a Folder
echo 7. Delete a Folder
echo 8. List Files in a Folder
echo 9. Exit
echo ================================
set /p choice="Enter your choice (1-9): "

REM Navigate to the chosen operation
if "%choice%"=="1" goto create_file
if "%choice%"=="2" goto delete_file
if "%choice%"=="3" goto rename_file
if "%choice%"=="4" goto copy_file
if "%choice%"=="5" goto move_file
if "%choice%"=="6" goto create_folder
if "%choice%"=="7" goto delete_folder
if "%choice%"=="8" goto list_files
if "%choice%"=="9" goto exit
echo Invalid choice! Please select a valid option.
pause
goto menu

:create_file
cls
set /p filename="Enter the full path (including name) for the new file: "
echo. > "%filename%"
echo File created successfully at "%filename%"
pause
goto menu

:delete_file
cls
set /p filename="Enter the full path of the file to delete: "
if exist "%filename%" (
    del "%filename%"
    echo File deleted successfully!
) else (
    echo File not found!
)
pause
goto menu

:rename_file
cls
set /p oldname="Enter the current full path of the file: "
if exist "%oldname%" (
    set /p newname="Enter the new name (with path) for the file: "
    ren "%oldname%" "%newname%"
    echo File renamed successfully!
) else (
    echo File not found!
)
pause
goto menu

:copy_file
cls
set /p source="Enter the full path of the source file: "
if exist "%source%" (
    set /p destination="Enter the destination path (including file name): "
    copy "%source%" "%destination%"
    echo File copied successfully!
) else (
    echo Source file not found!
)
pause
goto menu

:move_file
cls
set /p source="Enter the full path of the source file: "
if exist "%source%" (
    set /p destination="Enter the destination path (including file name): "
    move "%source%" "%destination%"
    echo File moved successfully!
) else (
    echo Source file not found!
)
pause
goto menu

:create_folder
cls
set /p foldername="Enter the full path of the folder to create: "
if not exist "%foldername%" (
    mkdir "%foldername%"
    echo Folder created successfully!
) else (
    echo Folder already exists!
)
pause
goto menu

:delete_folder
cls
set /p foldername="Enter the full path of the folder to delete: "
if exist "%foldername%" (
    rmdir /s /q "%foldername%"
    echo Folder deleted successfully!
) else (
    echo Folder not found!
)
pause
goto menu

:list_files
cls
set /p folderpath="Enter the folder path to list files: "
if exist "%folderpath%" (
    echo Files in "%folderpath%":
    dir /b "%folderpath%"
) else (
    echo Folder not found!
)
pause
goto menu

:exit
echo Exiting File Manager. Goodbye!
pause
exit
