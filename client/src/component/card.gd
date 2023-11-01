extends Component
class_name Card

var texture: Texture = load("res://assets/error.png") as Texture
var _on_tabel: bool = false
var _highlight := false
var _highlight_color := Color.aliceblue
#var _data

func _init(
	ctx: Context
#	parent: Component,
#	relative_type: int = 0,
#	offset: Vector2 = Vector2.ZERO,
#	custom_size: Vector2 = Vector2.ZERO
).(
	ctx
#	parent,
#	relative_type,
#	offset,
#	custom_size
) -> void:
	pass

func clone(card: Card) -> Card:
	card.set_position(_position)
	return card

func set_highlight(highlight: bool = true, color: Color = Color.aqua) -> void:
	_highlight_color = color
	_highlight = highlight

func highlight() -> bool:
	return _highlight

func highlight_color() -> Color:
	return _highlight_color

#func render(ctx: Context, card_size: Vector2, position: Vector2 = _position) -> void:
func render(ctx: Context) -> void:
	input(ctx)
#	if _on_tabel:
#		if visible():
#			ctx.canvas.draw_set_transform(center(), rotation(), scale())
#			ctx.canvas.draw_texture_rect(texture, rect(), false)
#			if highlight():
#				ctx.canvas.draw_rect(rect(), highlight_color(), false, 15)
#			ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
#			var position = position()
#			var size = size()
#			var pivot := size() * 0.5
#		#	var _pivot := size * 0.5 * _scale
#	#		ctx.draw_set_transform(position + _card_pivot, rotation, scale)
#	#		ctx.draw_texture_rect(_texture, Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
#			ctx.canvas.draw_texture_rect(texture, Rect2(position, size), false)
#			ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(size.x, 42)), Color.black)
#			ctx.canvas.draw_string(ctx.font, position - Vector2(0, 16), "Bill Amstrong")
#			ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(size.x, 42)), Color(255, 0 ,0))
#			ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(size.x, 42)), Color(219, 172 ,0))
#			ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(size.x, 42)), Color(163, 0 ,242))
#			ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(size.x, 42)), Color.black)
#			ctx.canvas.draw_string(ctx.font, position - Vector2(0, 16), "3000")
#			if highlight():
#				ctx.canvas.draw_rect(Rect2(position, size), highlight_color(), false, 30)
#	else:
	if visible():
#			var card_pivot := size() * 0.5 #* _scale
		var rect: Rect2 = rect()
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		ctx.canvas.draw_texture_rect(texture, rect, false)
		#	ctx.draw_rect()
		#	ctx.draw_string()
#		if animation.running():
#			animation.step(self, ctx.delta)
#		if mouse_hover():
#			ctx.canvas.draw_rect(rect, ctx.clicked_color if mouse_click() else ctx.hover_color, false, ctx.hover_line_size)
#		if highlight():
#			ctx.canvas.draw_rect(rect(), highlight_color(), false, 15)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
