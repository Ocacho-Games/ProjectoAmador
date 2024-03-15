extends RichTextLabel

func _process(_delta):
	text = "[b]" + str(SGPS.get_saved_data("coins", 0)) + "[/b]"
