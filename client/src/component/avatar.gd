extends Component
class_name Avatar

var _texture: Texture
#var screen: Screen
#var _card: Card

func init(pos: Vector2, size: Vector2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = Rect2(pos, size)

func input(sense: Sense):
	_hovered = true
	if _clicked:
		sense.send_action(Sense.EndTurn)

func output(sense: Sense):
	_hovered = false

func draw(ctx: CanvasItem):
	ctx.draw_texture_rect(_texture, _rect, false)
	ctx.draw_hovered(_rect, _focused, _clicked)