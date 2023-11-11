extends Node2D

func _on_button_pressed():
	if SGPS.is_game_loaded:
		SceneManager.change_scene("res://game/scenes/reel.tscn")
