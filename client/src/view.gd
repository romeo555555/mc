extends Object
class_name View

var _type: int = "None".hash()
var _texture: Texture
var _rect: Rect2
var _hightlight := false
var _hightlight_color := Color.aliceblue

func setup(rect: Rect2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = rect

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func get_type() -> int:
	return _type

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func set_hightlight(hightlight: bool):
	_hightlight = hightlight

func hightlight() -> bool:
	return _hightlight

func set_hightlight_color(color: Color, hightlight: bool = true):
	_hightlight_color = color
	_hightlight = hightlight

func hightlight_color() -> Color:
	return _hightlight_color

func draw(ctx: CanvasItem):
	ctx.draw_texture_rect(_texture, _rect, false)
	if _hightlight:
		ctx.draw_rect(_rect, _hightlight_color, false, 30)
#		_hightlight = false

