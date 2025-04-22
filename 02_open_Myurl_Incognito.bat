@echo off
echo This My Bash Script To Open MyUrl Incognito in Different Browsers and Different Mode.
title Open_URL_INCOGNITO_02
pause

echo Now Open Firefox in Private Window or Incognito Mode.
pause

start /d "C:\Program Files\Mozilla Firefox\" firefox.exe -private-window www.google.com
pause
echo Now Open Microsoft Edge in Private Window or Incognito.

pause
start msedge.exe -inprivate www.youtube.com/@sparrowsathya8278
pause
echo Now Open Another URL in Firefox as New Tab
pause
start Firefox -new-tab www.facebook.com
pause
