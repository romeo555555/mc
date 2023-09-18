extends View
class_name Graveyard

func setup(rect: Rect2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = rect
	_type = "Graveyard".hash()
