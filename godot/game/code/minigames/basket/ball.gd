extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

# Physics node
@onready var PhysicsNode : RigidBody2D = $RigidBody2D 

# Is the ball thrown?
var thrown : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================
# Called every frame for physics process. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	PhysicsNode.move_and_collide( PhysicsNode.linear_velocity * delta)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================
# Throws the ball with the given impulse vector
func throw( impulse : Vector2 ):
	PhysicsNode.linear_velocity = impulse
	PhysicsNode.freeze = false
	thrown = true
