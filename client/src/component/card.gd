extends Object
class_name Card

#var _rect: Rect2
var _texture: Texture
var _position: Vector2
var _rotation: float
var _scale: Vector2 = Vector2.ONE
var _visible := true
var _highlight := false
var _highlight_color := Color.aliceblue
#var _data

func setup(texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture

func set_texture(texture: Texture):
	_texture = texture

func texture() -> Texture:
	return _texture

func set_position(pos: Vector2):
	_position = pos

func position() -> Vector2:
	return _position

func set_rotation(rot: float):
	_rotation = rot

func rotation() -> float:
	return _rotation

func set_scale(scale: Vector2):
	_scale = scale

func scale() -> Vector2:
	return _scale

func set_visible(visible: bool):
	_visible = visible

func visible() -> bool:
	return _visible

func set_highlight(highlight: bool = true, color: Color = Color.aqua):
	_highlight_color = color
	_highlight = highlight

func highlight() -> bool:
	return _highlight

func highlight_color() -> Color:
	return _highlight_color
