extends Button

@export var random_song : AudioStream

var is_playing = 0
var is_first_time = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	if not is_playing:
		if is_first_time: 
			SoundManager.play_music_at_volume(random_song, 5, 0.5)
			is_first_time = false
		else:
			var last_played_song_path = SoundManager.get_last_played_music_track()
			SoundManager.play_music_at_volume(load(last_played_song_path),5,0.5)
		is_playing = true
	else:
		SoundManager.stop_music(0.5)
		is_playing = false
		
