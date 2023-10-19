extends Object
class_name Card

#var _rect: Rect2
var _texture: Texture
var _position: Vector2 = Vector2.ZERO
var _rotation: float = 0
var _scale: Vector2 = Vector2.ONE
var _visible := true
var _highlight := false
var _highlight_color := Color.aliceblue
#var _data

func init(texture: Texture = load("res://assets/error.png") as Texture) -> void:
	_texture = texture

func set_texture(texture: Texture) -> void:
	_texture = texture

func texture() -> Texture:
	return _texture

func set_position(pos: Vector2) -> void:
	_position = pos

func position() -> Vector2:
	return _position

func set_rotation(rot: float) -> void:
	_rotation = rot

func rotation() -> float:
	return _rotation

func set_scale(scale: Vector2) -> void:
	_scale = scale

func scale() -> Vector2:
	return _scale

func set_visible(visible: bool) -> void:
	_visible = visible

func visible() -> bool:
	return _visible

func set_highlight(highlight: bool = true, color: Color = Color.aqua) -> void:
	_highlight_color = color
	_highlight = highlight

func highlight() -> bool:
	return _highlight

func highlight_color() -> Color:
	return _highlight_color

func draw(ctx: CanvasItem, card_size: Vector2, position: Vector2 = _position) -> void:
	if visible():
		var card_pivot := card_size * 0.5 #* _scale
		ctx.draw_set_transform(position + card_pivot, rotation(), scale())
		ctx.draw_texture_rect(texture(), Rect2(Vector2.ZERO - card_pivot, card_size), false)
		#	ctx.draw_rect()
		#	ctx.draw_string()
		if highlight():
			ctx.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), highlight_color(), false, 15)

func draw_on_line(ctx: CanvasItem, card_size: Vector2, position: Vector2 = _position) -> void:
	if visible():
		var card_pivot := card_size * 0.5
	#	var _pivot := size * 0.5 * _scale
#		ctx.draw_set_transform(position + _card_pivot, rotation, scale)
#		ctx.draw_texture_rect(_texture, Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
		ctx.draw_texture_rect(texture(), Rect2(position, card_size), false)
		ctx.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.draw_string(ctx.font, position - Vector2(0, 16), "Bill Amstrong")
		ctx.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color(255, 0 ,0))
		ctx.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color(219, 172 ,0))
		ctx.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color(163, 0 ,242))
		ctx.draw_rect(Rect2(position - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.draw_string(ctx.font, position - Vector2(0, 16), "3000")
		if highlight():
			ctx.draw_rect(Rect2(position, card_size), highlight_color(), false, 30)

#TODO: draw an modal_draw
#func draw_modal(ctx: CanvasItem, card_size: Vector2, position: Vector2 = _position) -> void:
