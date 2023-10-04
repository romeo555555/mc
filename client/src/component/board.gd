extends Component
class_name Board

var _texture: Texture

func init(pos: Vector2, size: Vector2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = Rect2(pos, size)

func input(sense: Sense):
	pass

func output(sense: Sense):
	pass

func draw(ctx: CanvasItem):
	ctx.draw_texture_rect(_texture, _rect, false)
#	if _sense_rect.focused:
		#hovered ctx.hovered_color
	pass
