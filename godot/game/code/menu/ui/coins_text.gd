extends RichTextLabel

func _process(_delta):
	text = " " + str(SGPS.get_saved_data("coins", 0))
