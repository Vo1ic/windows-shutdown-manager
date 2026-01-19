@echo off
:: ============================================================
:: Name:        Safe Shutdown Manager
:: Description: Advanced CLI tool for scheduling Windows shutdowns
:: Author:      Vo1ic
:: Version:     3.1
:: ============================================================

chcp 65001 > nul
title PC Shutdown Manager v3.1
color B
cls

:MAIN_MENU
cls
echo ============================================================
echo                    PC SHUTDOWN MANAGER
echo ============================================================
echo.
echo  [1] Countdown Timer (e.g., in 30 minutes)
echo  [2] Specific Time   (e.g., at 23:00)
echo.
echo ============================================================
set /p "MODE=Select mode (1 or 2): "

if "%MODE%"=="1" goto COUNTDOWN
if "%MODE%"=="2" goto SPECIFIC_TIME
goto MAIN_MENU

:COUNTDOWN
cls
echo [MODE: COUNTDOWN TIMER]
echo.
set /p "INPUT_VAL=Enter minutes to wait (e.g. 60): "
echo %INPUT_VAL%| findstr /r "^[0-9]*$" > nul
if errorlevel 1 goto COUNTDOWN
set TYPE=duration
goto CONFIRM

:SPECIFIC_TIME
cls
echo [MODE: SPECIFIC TIME]
echo.
echo Enter time in 24h format (HH:mm).
set /p "INPUT_VAL=Enter time: "
echo %INPUT_VAL%| findstr ":" > nul
if errorlevel 1 goto SPECIFIC_TIME
set TYPE=target
goto CONFIRM

:CONFIRM
cls
echo.
echo  CRITICAL WARNING:
echo  ------------------------------------------------------------
echo  1. SAVE YOUR WORK: This tool uses "Safe Mode" (No Force).
echo     Apps with unsaved files (Word, Excel) WILL BLOCK shutdown.
echo     Please close them manually or save your data now.
echo.
echo  2. WINDOWS UPDATES: If updates are pending, the system
echo     may delay shutdown to install them.
echo  ------------------------------------------------------------
echo.
echo  [Timer Running... Press Ctrl+C to cancel immediately]
echo.

:: --- POWERSHELL LOGIC (SILENT KILL) ---
powershell -NoProfile -ExecutionPolicy Bypass -Command "$type = '%TYPE%'; $val = '%INPUT_VAL%'; [Console]::TreatControlCAsInput = $true; try { if ($type -eq 'duration') { $seconds = [int]$val * 60 } else { $target = [DateTime]::Parse($val); $now = Get-Date; if ($target -le $now) { $target = $target.AddDays(1) }; $seconds = ($target - $now).TotalSeconds }; $origPos = $host.UI.RawUI.CursorPosition; while ($seconds -gt 0) { if ([Console]::KeyAvailable) { $key = [Console]::ReadKey($true); if ($key.Modifiers -band [ConsoleModifiers]::Control -and $key.Key -eq 'C') { Write-Host ' Cancelled.' -ForegroundColor Red; exit } } $ts = [TimeSpan]::FromSeconds($seconds); $str = 'Shutdown pending in: {0:dd\.hh\:mm\:ss}' -f $ts; Write-Host $str -NoNewline; Start-Sleep -m 200; $seconds -= 0.2; $host.UI.RawUI.CursorPosition = $origPos; } Write-Host ''; Write-Host 'Timer complete. Shutting down...' -ForegroundColor Green; Start-Process 'shutdown.exe' -ArgumentList '/s /t 10'; Start-Sleep -s 3; } catch { exit }"

exit
