extends Node2D

@export var obstacle: PackedScene 

var timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)	
	timer.wait_time = 1
	timer.connect("timeout", _on_timer_timeout)
	#timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	var obstacle_node = obstacle.instantiate()
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	obstacle_node.position.x = randf_range(0, screen_width)
	obstacle_node.position.y = randf_range(-100, -500)
	get_parent().add_child(obstacle_node)
	
	var obstacle_node2 = obstacle.instantiate()
	obstacle_node.position.x = randf_range(0, screen_width)
	obstacle_node.position.y = randf_range(-100, -500)
	get_parent().add_child(obstacle_node2)

