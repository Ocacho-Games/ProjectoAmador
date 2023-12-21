GIT_ROOT_PATH=$(git rev-parse --show-toplevel)

DESTINATION_PATH=$GIT_ROOT_PATH/godot/

LOCALIZATION_PATH=$GIT_ROOT_PATH/godot/game/localization
LINK_LOCALIZATION_EXCEL=https://docs.google.com/spreadsheets/d/1_nm66MNoA1zymBRlSUbu-gO7j57r7ITFMtp_KpWK6FM/export?format=csv

## Install the addon if not installed yet
#1: Command for git after git clone
#2: Name of the repository folder
#3: Actual folder name of the plugin (The folder that appears on godot/addons)
function install_plugin()
{
    if not test -d $DESTINATION_PATH/addons/$3; then
        echo == Installing/Updating $2 ==
        git clone $1
        cp -rf $2/addons/ $DESTINATION_PATH
        rm -rf $2
    fi
}

# Updating Git submodules
echo == Updating Git Submodules ==
git submodule update --remote 

# Updating localization
echo [92m== Updating Localization ==
wget $LINK_LOCALIZATION_EXCEL -O $LOCALIZATION_PATH/localization.csv > /dev/null 2>&1

# Installing addons
install_plugin "-b godot_4 https://github.com/bitwes/Gut.git" Gut gut
install_plugin https://github.com/nathanhoad/godot_sound_manager.git godot_sound_manager sound_manager 
install_plugin https://github.com/glass-brick/Scene-Manager Scene-Manager scene_manager
install_plugin https://github.com/DmitriySalnikov/godot_debug_draw_3d.git godot_debug_draw_3d debug_draw_3d
install_plugin https://github.com/Poing-Studios/godot-admob-plugin.git godot-admob-plugin admob

# Installing addons that don't follow the pattern
if not test -d $DESTINATION_PATH/addons/touch_input_manager; then
    echo == Installing/Updating GodotTouchInputManager by Federico-Ciuffardi ==
    git clone -b godot4support https://github.com/Federico-Ciuffardi/GodotTouchInputManager.git
    mv GodotTouchInputManager $DESTINATION_PATH/addons/touch_input_manager
fi
