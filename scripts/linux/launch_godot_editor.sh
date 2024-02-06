#!/bin/bash

script_path=$(dirname $0)
godot_url=https://downloads.tuxfamily.org/godotengine/4.1.3/Godot_v4.1.3-stable_linux.x86_64.zip

if test -d $script_path/launch_godot_binaries; then
     echo Godot is already downloaded. No need to download 
else
    mkdir $script_path/launch_godot_binaries
    curl $godot_url -o $script_path/launch_godot_binaries/godot.zip
    cd $script_path/launch_godot_binaries
    unzip godot.zip
    rm godot.zip

fi

# Calling the setup
$script_path/setup.sh

# Launching godot
$script_path/launch_godot_binaries/Godot_v4.1.3-stable_linux.x86_64 -e --rendering-driver opengl3 --path $script_path/../../godot/ &