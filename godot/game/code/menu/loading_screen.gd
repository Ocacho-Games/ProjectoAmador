extends Node2D

func _ready():
	SGPS.GPGS.connect("_on_game_load_success", func(json_data): SceneManager.change_scene("res://game/scenes/reel.tscn"))
