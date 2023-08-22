@echo off
cls

:: Getting destination path
for /f "delims=" %%i in ('git rev-parse --show-toplevel') do set "GIT_ROOT_PATH=%%i"
set DESTINATION_PATH=%GIT_ROOT_PATH%\godot\addons\
set OVERWRITE_LIBRARIES=0

:: Get flags 
for %%A in (%*) do (
    if "%%A"=="/f" set OVERWRITE_LIBRARIES=1
)

:: Updating Git submodules
echo [92m== Updating Git Submodules ==
git submodule update --remote

:: Installing third party libraries if they aren't installed or they are forced (/f flag)
if not exist "%DESTINATION_PATH%\gut" (
    echo [94m== Installing/Updating GUT [Godot Unit Testing] by Bitwes == [90m
    git clone -b godot_4 https://github.com/bitwes/Gut.git
    xcopy Gut\addons "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q Gut
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating GUT [Godot Unit Testing] by Bitwes == [90m
    git clone -b godot_4 https://github.com/bitwes/Gut.git
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

if not exist "%DESTINATION_PATH%\godotsteam" (
    echo [94m== Installing/Updating Godot Steam by Gramps == [90m
    git clone -b gdextension-plugin https://github.com/CoaguCo-Industries/GodotSteam.git
    xcopy GodotSteam\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q GodotSteam
) else if %OVERWRITE_LIBRARIES%==1 (
    echo [94m== Installing/Updating Godot Steam by Gramps == [90m
    git clone -b gdextension-plugin https://github.com/CoaguCo-Industries/GodotSteam.git
    xcopy GodotSteam\addons\ "%DESTINATION_PATH%" /s /e /y
    rmdir /s /q GodotSteam
)
