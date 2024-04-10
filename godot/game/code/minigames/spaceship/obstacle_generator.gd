extends Node

@export var obstacles : Array[Obstacle]

# Time to wait before spwaning a new obstacle
@export var time_new_obstacle = 1.0

var timer : Timer = Timer.new()

## Used for vary the initial direction of Horizontal stuff when spawnning
var spawn_movement_right : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.wait_time = time_new_obstacle
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	var random_chance = randi_range(0, 100)
	
	var obstacle_node = null
	var current_chance = 0
	for obstacle in obstacles:
		current_chance += obstacle.chance
		if current_chance >= random_chance:
			obstacle_node = obstacle.scene.instantiate()
			break
	
	var screen_width = GameUtilityLibrary.SCREEN_WIDTH
	var obstacle_width = obstacle_node.get_child(0).texture.get_width() / 2
	obstacle_node.position.x = randf_range(obstacle_width, screen_width - obstacle_width)
	obstacle_node.position.y = -200
	
	var auto_movement_cmp = obstacle_node.get_node("AutoMovementCmp")
	assert(auto_movement_cmp)
	
	if !spawn_movement_right:
		auto_movement_cmp.current_direction = AutoMovementCmp.DIRECTION_LEFT
	
	get_parent().add_child(obstacle_node)
	spawn_movement_right = !spawn_movement_right
