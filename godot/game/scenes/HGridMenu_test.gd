extends HBoxContainer

var ori_size : Vector2 = Vector2(1.0,1.0)
var ft_size : bool = false

func _process(delta):
	if !ft_size :
		ori_size = size
		var new_x_size = ori_size.x * SApp.device_screen_scale.x
		var new_y_size = ori_size.y * SApp.device_screen_scale.y
		set_size(Vector2(new_x_size, new_y_size))
		var step_y = ori_size.y - new_y_size
		set_position( Vector2( position.x, position.y+step_y ) )
		ft_size = true
