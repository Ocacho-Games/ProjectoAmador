@echo off
cls

:: Setting path variables in order to make the script global
set WINDOWS_SCRIPTS_PATH=%~dp0
set REPO_PATH=%~dp0..\
FOR %%A IN ("%REPO_PATH%.") DO SET REPO_PATH=%%~dpA

:: Check if Godot has been downloaded or not and donwload it if needed
if exist "%WINDOWS_SCRIPTS_PATH%\launch_godot_binaries\Godot_v4.1.3-stable_win64.exe" (
    echo Godot is already downloaded. No need to download 
) else (
    mkdir "%WINDOWS_SCRIPTS_PATH%\launch_godot_binaries"
    curl https://downloads.tuxfamily.org/godotengine/4.1.3/Godot_v4.1.3-stable_win64.exe.zip --output "%WINDOWS_SCRIPTS_PATH%\launch_godot_binaries\godot.zip"
    cd "%WINDOWS_SCRIPTS_PATH%\launch_godot_binaries\"
    tar -xf godot.zip
    del godot.zip
)

:: Running the setup if needed
call %WINDOWS_SCRIPTS_PATH%\setup.bat

:: Launching godot in editor with our project
start "" "%WINDOWS_SCRIPTS_PATH%\launch_godot_binaries\Godot_v4.1.3-stable_win64.exe" -e --path "%REPO_PATH%/godot/"