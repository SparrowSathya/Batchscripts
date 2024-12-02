@echo off
title 04_Open_Files
echo This is My Batch Script to Open Files Automatically
pause
echo Now Going To Open Minikki Minikki Video Song from Thangalaan
pause
start kmplayer64 "F:\MY VIDEO SONGS\Minikki Minikki - Video Song (Tamil) _ Thangalaan _ Chiyaan Vikram _ Pa Ranjith _ GV Prakash Kumar.mp4"
pause
close kmplayer64.exe
echo Now Open Joker Image !
pause
start /d "C:\Program Files (x86)\Google\Picasa3" PicasaPhotoViewer.exe "F:\DOWNLOADS\peakpx.jpg"
pause
echo Now Open Grocery-Budget EXCEL File with EXCEL !
pause
start excel "D:\DOCUMENTS\EXCEL DATA\HOME\GROCERY BUDGET.xlsx"