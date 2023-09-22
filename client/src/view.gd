extends Object
class_name View

var _texture: Texture
var _rect: Rect2
var _highlight := false
var _highlight_color := Color.aliceblue

func setup(rect: Rect2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = rect

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func set_highlight(highlight: bool = true, color: Color = Color.aqua):
	_highlight_color = color
	_highlight = highlight

func highlight() -> bool:
	return _highlight

func highlight_color() -> Color:
	return _highlight_color

func mouse_enter(clicked: bool):
	set_highlight(true, (Color.red if clicked else Color.yellow))

func mouse_exit():
	set_highlight(false)

func draw(ctx: CanvasItem, font: Font):
#	if _texture:
	ctx.draw_texture_rect(_texture, _rect, false)
	if _highlight:
		ctx.draw_rect(_rect, _highlight_color, false, 30)
#		_highlight = false

