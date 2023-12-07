extends Node2D

func _ready():
	var DispSize = DisplayServer.screen_get_size()
	get_viewport().size = DispSize
	var SCREEN_HEIGHT : float = ProjectSettings.get_setting("display/window/size/window_width_override")
	var SCREEN_Width : float = ProjectSettings.get_setting("display/window/size/window_height_override")

func _on_button_pressed():
	if SGPS.is_game_loaded:
		SceneManager.change_scene("res://game/scenes/reel.tscn")
