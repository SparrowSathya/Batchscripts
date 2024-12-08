@echo off
Color A
title Kill_App By Sathya!
echo This Script to Kill App Speicified By Image Name /IM cmd
taskkill /IM notepad.exe
tasklist | findstr notepad.exe | | echo No NotePad Opened!
pause
