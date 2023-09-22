extends View
class_name Tabel

var avatar: Avatar = Avatar.new()
var _max_size_side := 4
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
#export(bool) var _miroring := false
#var _card_size := Vector2(200, 200)
var _card_size := Vector2.ZERO
var _card_pivot := _card_size * 0.5
var _x_indent := 0.0
var _left_count := 0
var _right_count := 0
var _cards: Array
var _margin: Rect2
#var _data

func setup(
	rect: Rect2, 
	texture: Texture = null,
	x_indent: float = 0, 
	margin_offset: Vector2 = Vector2.ZERO, 
	card_aspect: float = 1
):
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_card_size = Vector2(_margin.size.y * card_aspect, _margin.size.y)
	_card_pivot = _card_size * 0.5
	_x_indent = x_indent
	#TODO: avatar-size or aspect 1.5 _card_size
	avatar.setup(Rect2(rect.position + Vector2((rect.size.x - _card_size.x) * 0.5, 0), _card_size))
	_texture = texture
	_rect = rect

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func has_right_side(point: Vector2) -> bool:
	return point.x > _rect.size.x * 0.5
	
func has_point_on_card(point: Vector2, is_right: bool) -> int:
	var offset := _card_size.x + _x_indent
	if is_right:
		var pos := Vector2(avatar._rect.end.x + _x_indent, _margin.position.y)
		for i in range(_left_count, card_count()):
			if Rect2(pos, _card_size).has_point(point):
				return i
			pos.x += offset
	else: 
		var pos := Vector2(avatar._rect.position.x - _x_indent - _card_size.x, _margin.position.y)
		for i in range(_left_count - 1, -1, -1):
			if Rect2(pos, _card_size).has_point(point):
				return i
			pos.x -= offset
	return -1

func mouse_enter(clicked: bool):
#	set_highlight(true, (Color.red if clicked else Color.yellow))
	pass

func mouse_exit():
	aligment()

func draw(ctx: CanvasItem, font: Font):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	for card in _cards:
		if card.visible():
			#	var _pivot := size * 0.5 * _scale
#			ctx.draw_set_transform(card.position + _card_pivot, card.rotation, card.scale)
#			ctx.draw_texture_rect(_texture, Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
			ctx.draw_texture_rect(card.texture(), Rect2(card.position(), _card_size), false)
			ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(_card_size.x, 42)), Color.black)
			ctx.draw_string(font, card.position() - Vector2(0, 16), "Bill Amstrong")
			ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(_card_size.x, 42)), Color(255, 0 ,0))
			ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(_card_size.x, 42)), Color(219, 172 ,0))
			ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(_card_size.x, 42)), Color(163, 0 ,242))
			ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(_card_size.x, 42)), Color.black)
			ctx.draw_string(font, card.position() - Vector2(0, 16), "3000")
			if card.highlight():
				ctx.draw_rect(Rect2(Vector2.ZERO - _card_pivot, _card_size), card.hightlight_color(), false, 30)

#	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	avatar.draw(ctx, font)

func card_count() -> int:
	return _cards.size()

func is_full(is_right: bool) -> bool:
	if is_right:
		return _right_count == _max_size_side
	else:
		return _left_count == _max_size_side

func is_empety() -> bool:
	return _cards.size() == 0

func insert_card(card: Card, is_right: bool, idx: int = -1):
	if is_right:
		pass

func add_card(card: Card, is_right: bool, idx: int = -1):
	if is_right:
#		var x := avatar._rect.end.x + _x_indent \
#			+ (_card_size.x + _x_indent) * _right_count
#		card.set_position(Vector2(x, _margin.position.y))
#		card.set_rotation(0)
#		_cards.push_back(card)
		card.set_rotation(0)
		if idx > -1:
			_cards.insert(idx, card)
		else:
			_cards.push_back(card)
		aligment()
		_right_count += 1
	else:
#		var x := avatar._rect.position.x - _x_indent \
#		 - _card_size.x - (_card_size.x + _x_indent) * _left_count
#		_cards.push_front(card)
#		card.set_position(Vector2(x, _margin.position.y))
#		card.set_rotation(0)
		card.set_rotation(0)
		if idx > -1:
			_cards.insert(idx, card)
		else:
			_cards.push_front(card)
		aligment()
		_left_count += 1

func get_card(card_id: int) -> Card:
	return _cards[card_id]

func remove_card(idx: int) -> Card:
#	if card_count() == 0:
#		return null
	if idx > _left_count:
		_right_count -= 1
		return _cards.pop_at(idx)
	else:
		_left_count -= 1
		return _cards.pop_at(idx)

func aligment():
	var offset := _card_size.x + _x_indent
#	if is_right:
	var x := avatar._rect.end.x + _x_indent
	for i in range(_left_count, card_count()):
		_cards[i].set_position(Vector2(x, _margin.position.y))
		x += offset
#	else:
	var x1 := avatar._rect.position.x - _x_indent - _card_size.x
	for i in range(_left_count - 1, -1, -1):
		_cards[i].set_position(Vector2(x1, _margin.position.y))
		x1 -= offset

func casting_on(card_id: int, is_right: bool):
	aligment()
	var offset := _card_size.x + _x_indent
	if is_right:
		#check _cards.size != 0
		var card: Card = get_card(card_id)
		var x := card.position().x
#		var x := avatar._rect.end.x + _x_indent
#		x += offset * card_id
		for i in range(card_id, card_count()):
			x += offset
			_cards[i].set_position(Vector2(x, _margin.position.y))
	else:
		#check _cards.size != 0
		var card: Card = get_card(card_id)
		var x := card.position().x
#		var x := avatar._rect.position.x - _x_indent - _card_size.x
#		x -= offset * card_id
		for i in range(card_id, -1, -1):
			x -= offset
			_cards[i].set_position(Vector2(x, _margin.position.y))

#func handler(clicked: bool, card_id: int):
##	if card_id > -1:
##	if select.drag():
##		return
##	elif select.dragging():
##		return
##	elif select.drop():
##		return
##	elif clicked:
##		return
##	else:
#	print("tabel_id: ", card_id)
#	select_card = true
#	_cached_rect = Rect2(players[select_player].tabel._cards[card_id].position(), Vector2(200, 200))
#	if _drag:
#		var _card = players[select_player].tabel.remove(card_id)
#		print(_card)
#		card = _card
#		_drag = false
#	select.set_hovered(true)
