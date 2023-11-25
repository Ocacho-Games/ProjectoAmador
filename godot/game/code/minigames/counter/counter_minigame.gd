extends Minigame

@onready var counter_time_text : RichTextLabel = $counter_time_text
var counter_time : float
var is_counter_stopped : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	gps_leader_board_id = "CgkIr7WWkr4cEAIQBg"
	
	var rng = RandomNumberGenerator.new()
	counter_time = rng.randf_range(3.0, 5.0)
	counter_time_text.set_text(str("%.2f" % counter_time))
	
	
func _process(delta):
	super._process(delta)
	
	if(is_counter_stopped): return
	
	counter_time -= delta
	counter_time_text.set_text(str("%.2f" % counter_time))
	
	if counter_time < 0.0:
		on_should_change_to_next_minigame.emit()

#==============================================================================
# SIGNALS FUNCTIONS
#==============================================================================

func _on_counter_button_pressed():
	is_counter_stopped = true
	score = counter_time
	await get_tree().create_timer(2).timeout
	on_should_change_to_next_minigame.emit()
