@echo off
title Enhanced Cmd_Color
cls
:main_menu
echo ===========================
echo      CMD COLOR CHANGER     
echo ===========================
echo Available Colors:
echo 0 = Black       8 = Gray
echo 1 = Blue        9 = Light Blue
echo 2 = Green       A = Light Green
echo 3 = Aqua        B = Light Aqua
echo 4 = Red         C = Light Red
echo 5 = Purple      D = Light Purple
echo 6 = Yellow      E = Light Yellow
echo 7 = White       F = Bright White
echo ===========================
echo Format: BackgroundColor + TextColor (e.g., 0A, 1F, etc.)
echo ===========================
echo [R] Reset to Default
echo [E] Exit
echo ===========================
set /p user_input="Enter your choice: "

REM Validate Input
if "%user_input%"=="" goto main_menu
if /i "%user_input%"=="R" goto reset
if /i "%user_input%"=="E" goto exit

 

REM Apply Color
echo Changing color to %user_input%...
COLOR %user_input%
echo Color changed successfully!
pause
cls
goto main_menu

:reset
echo Resetting to default color...
COLOR 07
echo Default color restored!
pause
cls
goto main_menu

:exit
echo Exiting program. Goodbye!
pause
exit
