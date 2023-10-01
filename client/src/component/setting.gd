extends Component
class_name Setting

var _texture: Texture
var screen: Screen

func new(pos: Vector2, size: Vector2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = Rect2(pos, size)

func input(sense: Sense):
	_hovered = true
	if _clicked:
		sense.send_action(Sense.ScreenSetting)

func output(sense: Sense):
	_hovered = false

func draw(ctx: CanvasItem):
	ctx.draw_texture_rect(_texture, _rect, false)
	ctx.draw_hovered(_rect, _hovered, _clicked)


class Screen extends Component:
	var _texture: Texture

	func new(pos: Vector2, size: Vector2, texture: Texture = load("res://assets/error.png") as Texture):
		_texture = texture
		_rect = Rect2(pos, size)

	func input(sense: Sense):
		pass

	func output(sense: Sense):
		pass

	func draw(ctx: CanvasItem):
	#	if _sense_rect.focused:
			#hovered ctx.hovered_color
		pass
