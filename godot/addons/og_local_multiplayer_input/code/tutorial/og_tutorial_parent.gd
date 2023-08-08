extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _init():
	OGLocalMultiplayerInput.create_child_player_input(self)
	OGLocalMultiplayerInput.connect_on_input_disconnected(_on_input_disconnected, self)
	self.visible = false

## As an example this only makes visible the players that has its device connected
#func _process(delta):
#	if OGLocalMultiplayerInput.is_device_connected(self):
#		self.visible = true

func _on_input_disconnected():
	self.visible = false

func _input(event):
	# Enable the player
	var select_action = OGLocalMultiplayerInput.get_action_name("select", self)
	if Input.is_action_just_pressed(select_action):
		self.visible = true

	# Load the level only if we press face button down and we are the first player
	var down_action = OGLocalMultiplayerInput.get_action_name("down", self)
	if OGLocalMultiplayerInput.is_first_player(self):
		if Input.is_action_just_pressed(down_action) && self.visible == true:
			get_tree().change_scene_to_file("res://addons/og_local_multiplayer_input/scenes/tutorial/L_Gym.tscn")
