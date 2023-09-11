extends Object
class_name Card

var _texture: Texture
var _position: Vector2
var _rotation: float
var _scale: Vector2 = Vector2.ONE
#var _data

func setup(texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture

func set_position(pos: Vector2):
	_position = pos

func position() -> Vector2:
	return _position

func set_rotation(rotation: float):
	_rotation = rotation

func rotation() -> float:
	return _rotation

func set_scale(scale: Vector2):
	_scale = scale

func scale() -> Vector2:
	return _scale

func has_point(point: Vector2, size: Vector2) -> bool:
	#TODO: what about scale?
	return  Rect2(_position, size * _scale).has_point(point)

func draw(ctx: CanvasItem, size: Vector2):
#	ctx.draw_set_transform(Vector2.ZERO, _rotation, _scale)
	ctx.draw_texture_rect(_texture, Rect2(_position, size * _scale), false)
