@echo off
title USB Sound Installer
echo.

if not exist "%~dp0Connect Sound\" (
    echo ERROR: "Connect Sound" folder not found.
    goto fail
)
if not exist "%~dp0Disconnect Sound\" (
    echo ERROR: "Disconnect Sound" folder not found.
    goto fail
)

set count=0
for %%f in ("%~dp0Connect Sound\*.wav") do set /a count+=1
if %count%==0 (
    echo ERROR: No .wav file found in "Connect Sound".
    goto fail
)
if %count% GTR 1 (
    echo ERROR: More than one .wav file in "Connect Sound". Leave only one.
    goto fail
)

set count=0
for %%f in ("%~dp0Disconnect Sound\*.wav") do set /a count+=1
if %count%==0 (
    echo ERROR: No .wav file found in "Disconnect Sound".
    goto fail
)
if %count% GTR 1 (
    echo ERROR: More than one .wav file in "Disconnect Sound". Leave only one.
    goto fail
)

for %%f in ("%~dp0Connect Sound\*.wav")    do set "CONNECT_SRC=%%f"
for %%f in ("%~dp0Disconnect Sound\*.wav") do set "DISCONNECT_SRC=%%f"

echo Connect:    %CONNECT_SRC%
echo Disconnect: %DISCONNECT_SRC%
echo.

echo [1/3] Copying audio files...
copy /y "%CONNECT_SRC%"    "%WINDIR%\Media\usb_connect.wav" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Could not write to %WINDIR%\Media\ - try Run as Administrator.
    goto fail
)
copy /y "%DISCONNECT_SRC%" "%WINDIR%\Media\usb_disconnect.wav" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Could not write to %WINDIR%\Media\ - try Run as Administrator.
    goto fail
)

echo [2/3] Updating registry...
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current"     /ve /t REG_SZ /d "%WINDIR%\Media\usb_connect.wav"    /f >nul 2>&1
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Modified"    /ve /t REG_SZ /d "%WINDIR%\Media\usb_connect.wav"    /f >nul 2>&1
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current"  /ve /t REG_SZ /d "%WINDIR%\Media\usb_disconnect.wav" /f >nul 2>&1
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Modified" /ve /t REG_SZ /d "%WINDIR%\Media\usb_disconnect.wav" /f >nul 2>&1
if errorlevel 1 (
    echo ERROR: Registry update failed.
    goto fail
)

echo [3/3] Playing preview...
powershell -c "(New-Object Media.SoundPlayer '%WINDIR%\Media\usb_connect.wav').PlaySync()" >nul 2>&1
timeout /t 1 /nobreak >nul
powershell -c "(New-Object Media.SoundPlayer '%WINDIR%\Media\usb_disconnect.wav').PlaySync()" >nul 2>&1

echo.
echo Done. Plug in a USB device to hear it.
echo.
pause
exit /b 0

:fail
echo.
pause
exit /b 1
