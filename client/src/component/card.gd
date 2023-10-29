extends Component
class_name Card

#var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture
var _on_tabel: bool = false
var _highlight := false
var _highlight_color := Color.aliceblue
#var _data

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

func draw(ctx: Context, card_size: Vector2, position: Vector2 = _position) -> void:
	if visible():
		var card_pivot := card_size * 0.5 #* _scale
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		ctx.canvas.draw_texture_rect(texture, rect(), false)
		#	ctx.draw_rect()
		#	ctx.draw_string()
		if animation.running():
			animation.step(self, ctx.delta)
		if highlight():
			ctx.canvas.draw_rect(rect(), highlight_color(), false, 15)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)

func draw_on_line(ctx: Context, card_size: Vector2, position: Vector2 = _position) -> void:
	if visible():
		var card_pivot := card_size * 0.5
	#	var _pivot := size * 0.5 * _scale
#		ctx.draw_set_transform(position + _card_pivot, rotation, scale)
#		ctx.draw_texture_rect(_texture, Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
		ctx.canvas.draw_texture_rect(texture, Rect2(position, card_size), false)
		ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.canvas.draw_string(ctx.font, position - Vector2(0, 16), "Bill Amstrong")
		ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color(255, 0 ,0))
		ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color(219, 172 ,0))
		ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color(163, 0 ,242))
		ctx.canvas.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.canvas.draw_string(ctx.font, position - Vector2(0, 16), "3000")
		if highlight():
			ctx.canvas.draw_rect(Rect2(position, card_size), highlight_color(), false, 30)

#TODO: draw an modal_draw
#func draw_modal(ctx: CanvasItem, card_size: Vector2, position: Vector2 = _position) -> void:
