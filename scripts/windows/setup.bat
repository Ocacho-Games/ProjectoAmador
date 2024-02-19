@echo off
cls

:: Getting destination path
set WINDOWS_SCRIPTS_PATH=%~dp0
set REPO_PATH=%~dp0..\
FOR %%A IN ("%REPO_PATH%.") DO SET REPO_PATH=%%~dpA

set GODOT_GAME_PATH=%REPO_PATH%godot\game\
set DESTINATION_PATH=%REPO_PATH%godot\addons\
set OVERWRITE_LIBRARIES=0

:: Get flags 
for %%A in (%*) do (
    if "%%A"=="/f" set OVERWRITE_LIBRARIES=1
)

:: Updating Git submodules
@REM echo [92m== Updating Git Submodules ==
@REM cd /d "%REPO_PATH%"
@REM git submodule update --remote

:: Updating localization
echo [92m== Updating Localization ==
powershell wget https://docs.google.com/spreadsheets/d/1_nm66MNoA1zymBRlSUbu-gO7j57r7ITFMtp_KpWK6FM/export?format=csv -O "%GODOT_GAME_PATH%\localization\localization.csv"

:: Installing third party libraries if they aren't installed or they are forced (/f flag)
if not exist "%DESTINATION_PATH%\gut" (
    echo [94m== Installing/Updating GUT [Godot Unit Testing] by Bitwes == [90m
    git clone https://github.com/bitwes/Gut.git
    xcopy Gut\addons "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q Gut
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating GUT [Godot Unit Testing] by Bitwes == [90m
    git clone https://github.com/bitwes/Gut.git
    xcopy Gut\addons "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q Gut
)

if not exist "%DESTINATION_PATH%\scene_manager" (
    echo [94m== Installing/Updating Scene Manager by Glass Brick == [90m
    git clone https://github.com/glass-brick/Scene-Manager
    xcopy Scene-Manager\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q Scene-Manager
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating Scene Manager by Glass Brick == [90m
    git clone https://github.com/glass-brick/Scene-Manager
    xcopy Scene-Manager\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q Scene-Manager
)

if not exist "%DESTINATION_PATH%\sound_manager" (
    echo [94m== Installing/Updating Godot Sound Manager by Nathanhoad == [90m
    git clone https://github.com/nathanhoad/godot_sound_manager.git
    xcopy godot_sound_manager\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q godot_sound_manager
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating Godot Sound Manager by Nathanhoad == [90m
    git clone https://github.com/nathanhoad/godot_sound_manager.git
    xcopy godot_sound_manager\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q godot_sound_manager
)

if not exist "%DESTINATION_PATH%\debug_draw_3d" (
    echo [94m== Installing/Updating Godot Debug Draw 3D by DmitriySalnikov == [90m
    git clone https://github.com/DmitriySalnikov/godot_debug_draw_3d.git
    xcopy godot_debug_draw_3d\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q godot_debug_draw_3d
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating Godot Debug Draw 3D by DmitriySalnikov == [90m
    git clone https://github.com/DmitriySalnikov/godot_debug_draw_3d.git
    xcopy godot_debug_draw_3d\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q godot_debug_draw_3d
)

if not exist "%DESTINATION_PATH%\touch_input_manager" (
    echo [94m== Installing/Updating GodotTouchInputManager by Federico-Ciuffardi == [90m
    git clone https://github.com/Federico-Ciuffardi/GodotTouchInputManager.git
    mkdir "%DESTINATION_PATH%"\touch_input_manager
    xcopy GodotTouchInputManager\*.gd "%DESTINATION_PATH%"\touch_input_manager /s /e /y
    rmdir /s /q GodotTouchInputManager
    rmdir /s /q "%DESTINATION_PATH%"\touch_input_manager\.github
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating GodotTouchInputManager by Federico-Ciuffardi == [90m
    git clone https://github.com/Federico-Ciuffardi/GodotTouchInputManager.git
    mkdir "%DESTINATION_PATH%"\touch_input_manager
    xcopy GodotTouchInputManager\*.gd "%DESTINATION_PATH%"\touch_input_manager /s /e /y
    rmdir /s /q GodotTouchInputManager
    rmdir /s /q "%DESTINATION_PATH%"\touch_input_manager\.github
)

if not exist "%DESTINATION_PATH%\admob" (
    echo [94m== Installing/Updating Godot Admob by Gummaciel == [90m
    git clone https://github.com/Poing-Studios/godot-admob-plugin.git
    xcopy godot-admob-plugin\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q godot-admob-plugin
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating Godot Admob by Gummaciel == [90m
    git clone https://github.com/Poing-Studios/godot-admob-plugin.git
    xcopy godot-admob-plugin\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q godot-admob-plugin
)