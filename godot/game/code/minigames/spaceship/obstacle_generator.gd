extends Node

@export var obstacle_asteroid: PackedScene
@export var obstacle_ovni: PackedScene 
@export var obstacle_ship: PackedScene 

var timer : Timer = Timer.new()

@export var enable : bool = false

var spawn_movement_right : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)	
	timer.wait_time = 1.0
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	var random_obstacle_id = randi_range(0, 2)
	var obstacle_node
	
	match random_obstacle_id:
		0: obstacle_node = obstacle_asteroid.instantiate()
		1: obstacle_node = obstacle_ovni.instantiate()
		2: obstacle_node = obstacle_ship.instantiate()		
	
	var screen_width = GameUtilityLibrary.SCREEN_WIDTH
	var obstacle_width = obstacle_node.get_child(0).texture.get_width()
	obstacle_node.position.x = randf_range(obstacle_width, screen_width - obstacle_width)
	obstacle_node.position.y = -200
	
	var auto_movement_cmp = obstacle_node.get_node("AutoMovementCmp")
	assert(auto_movement_cmp)
	
	if !spawn_movement_right:
		auto_movement_cmp.current_direction = AutoMovementCmp.DIRECTION_LEFT
	
	get_parent().add_child(obstacle_node)
	spawn_movement_right = !spawn_movement_right
	
#	var obstacle_node2 = obstacle.instantiate()
#	obstacle_node.position.x = randf_range(obstacle_width * 2, screen_width - obstacle_width)
#	obstacle_node.position.y = randf_range(-100, -500)
#	get_parent().add_child(obstacle_node2)

