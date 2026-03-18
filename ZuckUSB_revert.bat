@echo off
title USB Sound Reverter
echo.

echo [1/2] Restoring registry...
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current"     /ve /t REG_SZ /d "%SystemRoot%\Media\Windows Hardware Insert.wav"  /f >nul 2>&1
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Modified"    /ve /t REG_SZ /d "%SystemRoot%\Media\Windows Hardware Insert.wav"  /f >nul 2>&1
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current"  /ve /t REG_SZ /d "%SystemRoot%\Media\Windows Hardware Remove.wav" /f >nul 2>&1
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Modified" /ve /t REG_SZ /d "%SystemRoot%\Media\Windows Hardware Remove.wav" /f >nul 2>&1
if errorlevel 1 (
    echo ERROR: Registry restore failed. Try Run as Administrator.
    echo.
    pause
    exit /b 1
)

echo [2/2] Removing audio files...
if exist "%WINDIR%\Media\usb_connect.wav"    del /f "%WINDIR%\Media\usb_connect.wav"
if exist "%WINDIR%\Media\usb_disconnect.wav" del /f "%WINDIR%\Media\usb_disconnect.wav"

echo.
echo Done.
echo.
pause
exit /b 0
