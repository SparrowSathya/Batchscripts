@echo off
setlocal

rem Define the log file
set "LOGFILE=batch.log"



rem Use the helper subroutine to log each line
call :LogMsg "****************************************"
call :LogMsg "*            SYSTEM CLEANUP            *"
call :LogMsg "****************************************"
call :LogMsg "Cleanup started at %date% %time%"
call :LogMsg "****************************************"
exit /B

:LogMsg
rem %~1 removes any surrounding quotes from the parameter
echo %~1
echo %~1 >> "%LOGFILE%"
exit /B