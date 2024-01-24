@echo off
cls

:: Setting path variables in order to make the script global
set WINDOWS_SCRIPTS_PATH=%~dp0

:: Calling the setup.bat forcing the libraries to install
"%WINDOWS_SCRIPTS_PATH%\setup.bat" /f