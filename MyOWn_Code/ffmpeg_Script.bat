@echo off
title Video Compressor using FFmpeg
setlocal enabledelayedexpansion

:check_ffmpeg
REM Check if FFmpeg is installed
ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo FFmpeg is not installed or not in PATH.
    echo Please install FFmpeg and ensure it is added to your system PATH.
    pause
    exit
)

:menu
cls
echo =====================================
echo         VIDEO COMPRESSOR
echo =====================================
echo 1. Select Video File
echo 2. Set Compression Quality
echo 3. Start Compression
echo 4. Exit
echo =====================================
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto select_video
if "%choice%"=="2" goto set_quality
if "%choice%"=="3" goto compress_video
if "%choice%"=="4" goto exit

echo Invalid choice! Please select a valid option.
pause
goto menu

:select_video
cls
echo =====================================
echo        SELECT VIDEO FILE
echo =====================================
set /p input_video="Enter the full path of the video file: "
if not exist "%input_video%" (
    echo File not found! Please try again.
    pause
    goto menu
)
echo Selected Video: %input_video%
pause
goto menu

:set_quality
cls
echo =====================================
echo       SET COMPRESSION QUALITY
echo =====================================
echo Choose a quality level:
echo 1. High Quality (Lower Compression)
echo 2. Medium Quality
echo 3. Low Quality (Higher Compression)
echo =====================================
set /p quality_choice="Enter your choice (1-3): "

if "%quality_choice%"=="1" set crf=20
if "%quality_choice%"=="2" set crf=28
if "%quality_choice%"=="3" set crf=35

if not defined crf (
    echo Invalid choice! Please try again.
    pause
    goto menu
)
echo Selected Compression Quality: CRF=%crf%
pause
goto menu

:compress_video
cls
if not defined input_video (
    echo No video selected! Please select a video file first.
    pause
    goto menu
)
if not defined crf (
    echo No compression quality selected! Please set the quality first.
    pause
    goto menu
)

echo =====================================
echo       STARTING COMPRESSION
echo =====================================
set output_video="%~dp0compressed_output.mp4"

REM Display original file size
for %%A in ("%input_video%") do set original_size=%%~zA
set /a original_size_kb=%original_size% / 1024
echo Original File Size: %original_size_kb% KB

REM Compress the video using FFmpeg
ffmpeg -i "%input_video%" -vcodec libx264 -crf %crf% -preset slow %output_video%
if errorlevel 1 (
    echo Compression failed! Please check the input file and FFmpeg setup.
    pause
    goto menu
)

REM Display compressed file size
for %%B in (%output_video%) do set compressed_size=%%~zB
set /a compressed_size_kb=%compressed_size% / 1024
echo Compression Completed Successfully!
echo Compressed File: %output_video%
echo Compressed File Size: %compressed_size_kb% KB

pause
goto menu

:exit
echo Exiting Video Compressor. Goodbye!
pause
exit
