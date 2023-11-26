extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

# Physics node
@onready var PhysicsNode : RigidBody2D = $RigidBody2D 

# Is the ball had been thrown
var thrown : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Called every frame for physics process. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	PhysicsNode.move_and_collide( PhysicsNode.linear_velocity * delta)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

# Gets if the ball is thrown
func get_thrown():
	return thrown

# Throws the ball with the given impulse vector
func throw( impulse : Vector2 ):
	PhysicsNode.linear_velocity = impulse
	PhysicsNode.freeze = false
	thrown = true
