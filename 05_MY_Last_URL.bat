@echo off
title MY_LAST_URLS List
echo This Script is for Opening My Last Url From MyUrls.txt File.

:: Check if MyUrls.txt exists
if not exist MyUrls.txt (
    echo Error: MyUrls.txt file not found!
    pause
    exit /b
)
pause

:: Loop through URLs
for /f "delims=" %%i in (MyUrls.txt) do (

		start firefox "%%i"
	
)
echo All URLs have been opened in Firefox.
pause
