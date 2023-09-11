extends Object
class_name View

var _texture: Texture
var _rect: Rect2

func setup(rect: Rect2 = Rect2(0, 0, 200, 270), texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = rect

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func draw(ctx: CanvasItem):
	ctx.draw_texture_rect(_texture, _rect, false)
