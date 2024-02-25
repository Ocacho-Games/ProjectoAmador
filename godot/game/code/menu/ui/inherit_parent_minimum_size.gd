extends Control

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	assert(get_parent() is Control)
	custom_minimum_size = get_parent().custom_minimum_size
