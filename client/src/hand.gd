extends Object
class_name Hand

var _max_size := 10
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
#export(bool) var _miroring := false
var _card_size := Vector2(200, 200)
var _x_indent := 0.0
var _hand_twist := 0.15
var _hand_height := 25.0
var _cards: Array
var _texture: Texture
var _margin: Rect2
var _rect: Rect2
#var _data

func setup(
	rect: Rect2, 
	x_indent: float = 0, 
	margin_offset: Vector2 = Vector2.ZERO, 
	card_aspect: float = 1, 
	texture: Texture = null
):
	_texture = texture
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_rect = rect
	_card_size = Vector2(_margin.size.y * card_aspect, _margin.size.y)
	_x_indent = x_indent

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func has_point_on_card(point: Vector2) -> int:
	if point.x > _rect.position.x * 0.5:
		for i in range(0, card_count()):
			if _cards[i].has_point(point, _card_size):
				return i
	return -1

func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	for card in _cards:
		card.draw(ctx, _card_size)
	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func card_count() -> int:
	return _cards.size()

func can_add_card() -> bool:
	return !card_count() == _max_size

func add_card(card: Card):
	_cards.push_back(card)
	aligment()

#func get_card(card_id: int) -> Node:
#	return get_child(card_id)
#
#func remove_card_right(idx: int):
##	if idx == _avatar_id:
##		return
#	remove_child(get_child(idx))

func aligment():
	var count := card_count()
	var offset := _card_size.x + _x_indent
	var start_x := (count * offset - _x_indent) * -1
	var x := (_rect.size.x + start_x) * 0.5
	var angel = -(_hand_twist * count / 2)
	var y =  _margin.position.y + _hand_height * count / 2 
	for i in range(0, count):
		var card = _cards[i]
		card.set_position(Vector2(x, abs(y)*1))
		card.set_rotation(angel)
		x += offset
		angel += _hand_twist
		y = y - _hand_height
