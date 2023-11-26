extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

# Physics node
@onready var physics_node : RigidBody2D = $RigidBody2D 

# Is the ball thrown?
var thrown : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================
# Called every frame for physics process. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	physics_node.move_and_collide( physics_node.linear_velocity * delta)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================
# Throws the ball with the given impulse vector
func throw( impulse : Vector2 ):
	physics_node.linear_velocity = impulse
	physics_node.freeze = false
	thrown = true
