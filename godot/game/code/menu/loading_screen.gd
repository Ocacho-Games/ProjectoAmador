extends Node2D

func _ready():
	if OS.get_name() == "Android":
		SGPS.GPGS.connect("_on_game_load_success", func(_json_data): SceneManager.change_scene("res://game/scenes/reel.tscn"))
	else:
		SceneManager.change_scene("res://game/scenes/reel.tscn")
