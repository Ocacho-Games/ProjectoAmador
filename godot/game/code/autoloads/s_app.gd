## Autoload in charge of managing the minigames array and global game data
## It also provides handy functionality for Minigame.gd instances
##
extends Node


#==============================================================================
# VARIABLES
#==============================================================================

var device_screen_scale : Vector2 = Vector2(1.0,1.0)

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	_calculate_screen_scale()

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

func _calculate_screen_scale():
	var design_width = float(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var design_heigth = float(ProjectSettings.get_setting("display/window/size/viewport_height"))
	var device_screen_size = Vector2(DisplayServer.screen_get_size())
	var width_scale = device_screen_size.x/design_width
	var height_scale = device_screen_size.y/design_heigth
	device_screen_scale = Vector2( width_scale, height_scale )
