extends Node2D

@export var obstacle: PackedScene 

var timer : Timer = Timer.new()

@export var enable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)	
	timer.wait_time = 0.75
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	var obstacle_node = obstacle.instantiate()
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var obstacle_width = obstacle_node.get_child(0).texture.get_width()
	obstacle_node.position.x = randf_range(obstacle_width, screen_width - obstacle_width)
	obstacle_node.position.y = -200
	get_parent().add_child(obstacle_node)
	
#	var obstacle_node2 = obstacle.instantiate()
#	obstacle_node.position.x = randf_range(obstacle_width * 2, screen_width - obstacle_width)
#	obstacle_node.position.y = randf_range(-100, -500)
#	get_parent().add_child(obstacle_node2)

