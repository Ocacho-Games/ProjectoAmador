echo == Updating Git Submodules ==
git submodule update --remote 

echo == Installing/Updating GUT (Godot Unit Testing) by Bitwes ==
git clone -b godot_4 https://github.com/bitwes/Gut.git
cp -rf Gut/addons ../godot/addons
rm -rf Gut

echo == Installing/Updating Scene Manager by Glass Brick ==
git clone https://github.com/glass-brick/Scene-Manager
cp -rf Scene-Manager/addons/ ../godot/addons
rm -rf Scene-Manager

echo == Installing/Updating Godot Sound Manager by Nathanhoad ==
git clone https://github.com/nathanhoad/godot_sound_manager.git
cp -rf godot_sound_manager/addons/ ../godot/addons
rm -rf godot_sound_manager

echo == Installing/Updating Godot Debug Draw 3D by DmitriySalnikov ==
git clone https://github.com/DmitriySalnikov/godot_debug_draw_3d.git
cp -rf godot_debug_draw_3d/addons/ ../godot/addons
rm -rf godot_debug_draw_3d

echo == Installing/Updating Godot Steam by Gramps ==
git clone -b gdextension-plugin https://github.com/CoaguCo-Industries/GodotSteam.git
cp -rf GodotSteam/addons/ ../godot/addons
rm -rf GodotSteam
