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
	
func _mouse_enter(sense: Sense) -> bool:
	if _rect.has_point(sense.mouse_pos()):
		if sense.targeting():
			targeting(sense)
		if sense.dragging():
			dragging(sense)
		else:
			input(sense)
			hovered(sense)
		return true
	return false

func _mouse_exit(sense: Sense):
	output(sense)
	unhovered(sense)

func input(sense: Sense):
	pass

func dragging(sense: Sense):
	pass

func targeting(sense: Sense):
	pass

func output(sense: Sense):
	pass

func hovered(sense: Sense):
#	sense.set_hovered(true)
	set_highlight(true, (Color.red if sense.clicked() else Color.yellow))

func unhovered(sense: Sense):
#	sense.set_hovered(false)
	set_highlight(false)

func set_highlight(highlight: bool = true, color: Color = Color.aqua):
	_highlight_color = color
	_highlight = highlight

func highlight() -> bool:
	return _highlight

func highlight_color() -> Color:
	return _highlight_color

func draw(ctx: CanvasItem):
#	if _texture:
	ctx.draw_texture_rect(_texture, _rect, false)
	if _highlight:
		ctx.draw_rect(_rect, _highlight_color, false, 30)
#		_highlight = false

