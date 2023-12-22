extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var ori_scale = get_transform().get_scale()
	var new_x_scale = ori_scale.x * SApp.device_screen_scale.y
	var new_y_scale = ori_scale.y * SApp.device_screen_scale.x
	scale = Vector2(new_x_scale, new_y_scale)
	pass # Replace with function body.
