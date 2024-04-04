class_name InputDetection

static func check_position_in_area( pos : Vector2, area : Rect2 ) -> bool:
	return area.has_point(pos)
