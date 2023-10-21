extends Node2D

var my_data = SSaveData.new()

func _ready():
	print(my_data.data)
	SGPS.init(my_data)

func _on_button_pressed():
	my_data.data["test_array"] = [1,2,3,4,5,6]
	SGPS.save_game()
		
func _on_button_load_pressed():
	print(my_data.data)	
