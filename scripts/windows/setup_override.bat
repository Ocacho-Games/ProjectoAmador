@echo off
cls

:: Setting path variables in order to make the script global
for /f "delims=" %%i in ('git rev-parse --show-toplevel') do set "GIT_ROOT_PATH=%%i"
set WINDOWS_SCRIPTS_PATH=%GIT_ROOT_PATH%\scripts\windows\

:: Calling the setup.bat forcing the libraries to install
"%WINDOWS_SCRIPTS_PATH%\setup.bat" /f