class_name STrackVariable

var value
var old_value

func _init(initial_value):
	set_value(initial_value)

func set_value(new_value) -> void:
	old_value = value	
	value = new_value

func has_changed(is_current_value) -> bool:
	return value != old_value and value == is_current_value 
