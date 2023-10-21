extends Node2D

func _ready():
	print(SGPS.data_to_save.dictionary)	

func _on_button_pressed():
	SGPS.data_to_save.dictionary["test_array"] = [1,2,3,4,5,6]
	SGPS.save_game()
		
func _on_button_load_pressed():
	print(SGPS.data_to_save.dictionary)	
