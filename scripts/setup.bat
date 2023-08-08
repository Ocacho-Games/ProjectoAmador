@echo off
cls

echo [92m== Updating Git Submodules ==
git submodule update --remote 

echo [94m== Installing/Updating GUT (Godot Unit Testing) by Bitwes == [90m
git clone -b godot_4 https://github.com/bitwes/Gut.git
xcopy Gut\addons ..\godot\addons /s /e /y
rmdir /s /q Gut

echo [94m== Installing/Updating Scene Manager by Glass Brick == [90m
git clone https://github.com/glass-brick/Scene-Manager
xcopy Scene-Manager\addons\ ..\godot\addons /s /e /y
rmdir /s /q Scene-Manager

echo [94m== Installing/Updating Godot Sound Manager by Nathanhoad == [90m
git clone https://github.com/nathanhoad/godot_sound_manager.git
xcopy godot_sound_manager\addons\ ..\godot\addons /s /e /y
rmdir /s /q godot_sound_manager

echo [94m== Installing/Updating Godot Debug Draw 3D by DmitriySalnikov == [90m
git clone https://github.com/DmitriySalnikov/godot_debug_draw_3d.git
xcopy godot_debug_draw_3d\addons\ ..\godot\addons /s /e /y
rmdir /s /q godot_debug_draw_3d

echo [94m== Installing/Updating Godot Steam by Gramps == [90m
git clone -b gdextension-plugin https://github.com/CoaguCo-Industries/GodotSteam.git
xcopy GodotSteam\addons\ ..\godot\addons /s /e /y
rmdir /s /q GodotSteam
