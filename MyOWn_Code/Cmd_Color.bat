@echo off
title Cmd_Color
cls
echo This Scrit to Change the Command Prompt Color.
help color
:start
set /p user_input="Choose Color (A to F) & (1 to 9): "

echo "You can Combine Selection "81" 8=Background Color & 1=Text Color"

echo You are Choosing %user_input% color wil be Changed.
pause
COLOR %user_input%
echo Color Changed Successfully !
pause
goto :start