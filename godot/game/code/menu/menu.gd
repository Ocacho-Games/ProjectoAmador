extends Node2D

var test_minigame = Minigame.new()

func _ready():
	print(SGPS.data_to_save.dictionary)	

func _on_button_pressed():
	#SGPS.data_to_save.dictionary["test_array"] = [1,2,3,4,5,6]
	#SGPS.save_game()
	SGPS.show_leaderboard(test_minigame)
		
func _on_button_load_pressed():
	print(SGPS.data_to_save.dictionary)	
	SGPS.submit_leaderboard_score(test_minigame, 10)
