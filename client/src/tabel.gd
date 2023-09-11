extends Object
class_name Tabel

var avatar: Avatar = Avatar.new()
var _max_size_side := 4
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
#export(bool) var _miroring := false
var _card_size := Vector2(200, 200)
var _x_indent := 0.0
var _left_count := 0
var _right_count := 0
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
	#TODO: avatar-size or aspect 1.5 _card_size
	avatar.setup(Rect2(rect.position + Vector2((rect.size.x - _card_size.x) * 0.5, 0), _card_size))

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func has_point_on_card(point: Vector2) -> int:
	if point.x > _rect.size.x * 0.5:
		for i in range(_left_count, card_count()):
			if _cards[i].has_point(point, _card_size):
				return i
	else: 
		for i in range(0, _left_count + 1):
			if _cards[i].has_point(point, _card_size):
				return i
	return -1

func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	for card in _cards:
		draw_card(ctx, card)
	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	avatar.draw(ctx)

func draw_card(ctx: CanvasItem, card: Card):
	ctx.draw_texture_rect(card._texture, Rect2(card.position(), _card_size), false)
	pass

func card_count() -> int:
	return _cards.size()

func can_cast_right() -> bool:
	return !_right_count == _max_size_side

func can_cast_left() -> bool:
	return !_left_count == _max_size_side

func cast_right(card: Card):
	var x := avatar._rect.end.x + _x_indent \
		+ (_card_size.x + _x_indent) * _right_count
	_cards.push_back(card)
	card.set_position(Vector2(x, _margin.position.y))
	_right_count += 1

func cast_left(card: Card):
	var x := avatar._rect.end.x - avatar._rect.size.x - _x_indent \
	 - _card_size.x - (_card_size.x + _x_indent) * _left_count
	_cards.push_front(card)
	card.set_position(Vector2(x, _margin.position.y))
	_left_count += 1

#func get_card(card_id: int) -> Node:
#	return get_child(card_id)
#
#func remove_card_right(idx: int):
##	if idx == _avatar_id:
##		return
#	remove_child(get_child(idx))

func aligment_left():
	var offset := _card_size.x + _x_indent
	var x := avatar._rect.end.x - _x_indent \
	 - _card_size.x - (_card_size.x + _x_indent) * _left_count
	for i in range(0, _left_count):
		_cards[i].set_position(Vector2(x, _margin.position.y))
		x -= offset

func aligment_right():
	var offset := _card_size.x + _x_indent
	var x := avatar._rect.end.x + _x_indent \
		+ (_card_size.x + _x_indent) * _right_count
	for i in range(_left_count, card_count()):
		_cards[i].set_position(Vector2(x, _margin.position.y))
		x += offset

#func aligment_left():
#	aligment()
#	var offset := _card_size + _card_indent
#	offset.y = 0
#	var fchild := select_card()
#	var pos: Vector2 = fchild.get_rect().position - offset 
#	pos.x += _card_size.x
#	fchild.set_position(pos)
#	for i in range(_cached_card_id, _left_count):
#		pos -= offset
#		get_child(i).set_position(pos)
#
#func aligment_right():
#	aligment()
#	var offset := _card_size + _card_indent
#	offset.y = 0
#	var fchild := select_card()
#	var pos: Vector2 = fchild.get_rect().position + offset
#	fchild.set_position(pos)
#	for i in range(_cached_card_id, card_count()):
#		pos += offset
#		get_child(i).set_position(pos)
