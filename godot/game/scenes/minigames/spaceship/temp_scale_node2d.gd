extends Node2D

var ori_scale : Vector2 = Vector2(1.0,1.0)

func _init():
	ori_scale = get_transform().get_scale()

func _enter_tree():
#	var new_x_scale = ori_scale.x * SApp.device_screen_scale.y
#	var new_y_scale = ori_scale.y * SApp.device_screen_scale.x
#	scale = Vector2(new_x_scale, new_y_scale)
