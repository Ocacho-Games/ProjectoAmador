class_name ProfileLeaderboardButton extends Control

var leaderboard_id : String

func set_properties(minigame_data : SMinigameData):
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "asset").set_texture(minigame_data.game_sprite)
	leaderboard_id = minigame_data.leaderboard_key

func _on_box_button_pressed():
	SGPS.show_leaderboard(leaderboard_id)
