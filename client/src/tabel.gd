extends View
class_name Tabel

var _max_size_line := 4
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
#export(bool) var _miroring := false
#var _card_size := Vector2(200, 200)
var _margin: Rect2
var _card_size := Vector2.ZERO
var _card_pivot := Vector2.ZERO
var _avatar_rect: Rect2
var _avatar_pivot := Vector2.ZERO
var _x_indent := 0.0

var _left_count := 0
var _right_count := 0
var _avatar_id := 0
var _cards: Array

var _left_line: Line = Line.new()
var _right_line: Line = Line.new()
#var _data

class Line:
	var _miroring := false
	var _cards: Array


func setup(
	id: int,
	rect: Rect2, 
	texture: Texture = null,
	avatar: Card = null,
	x_indent: float = 0, 
	margin_offset: Vector2 = Vector2.ZERO, 
	card_aspect_x: float = 1,
	avatar_aspect_y: float = 1.25
):
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_card_size = Vector2(_margin.size.y * card_aspect_x, _margin.size.y)
	_card_pivot = _card_size * 0.5
	_x_indent = x_indent
	var avatar_size: Vector2 = Vector2(_card_size.x, _card_size.y * avatar_aspect_y)
	_avatar_rect = Rect2(Vector2(rect.position.x + (rect.size.x - _card_size.x) * 0.5, 
		rect.position.y + (rect.size.y - avatar_size.y) * 0.5), avatar_size)
	_avatar_pivot = avatar_size * 0.5
	avatar.set_position(_avatar_rect.position)
#	_cards.resize(_max_size_line * 2 + 1)
	_cards.push_back(avatar)
#	avatar.setup(Rect2(rect.position + Vector2((rect.size.x - _card_size.x) * 0.5, 0), _card_size))
	_texture = texture
	_rect = rect
	_id = id
	print(rect)
	print(_margin)

func card_count() -> int:
	return _right_count + _left_count + 1

func is_full(is_right: bool) -> bool:
	if is_right:
		return _right_count == _max_size_line
	else:
		return _left_count == _max_size_line

func is_empety() -> bool:
	return _cards.size() == 0

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
		_right_count += 1
		aligment()
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
		_avatar_id += 1
		_left_count += 1
		aligment()

func has_card(card_id: int) -> bool:
	return _cards.has(card_id)

func get_card(card_id: int) -> Card:
	if _cards.has(card_id):
		return _cards[card_id]
	else:
		return null

func remove_card(idx: int) -> Card:
#	if card_count() == 0:
#		return null
	if idx > _left_count:
		_right_count -= 1
		return _cards.pop_at(idx)
	else:
		_avatar_id -= 1
		_left_count -= 1
		return _cards.pop_at(idx)

func aligment():
	var offset := _card_size.x + _x_indent
#	if is_right:
	var x := _avatar_rect.end.x + _x_indent
	for i in range(_avatar_id + 1, card_count()):
		print(i)
		_cards[i].set_position(Vector2(x, _margin.position.y))
		x += offset
#	else:
	var x1 := _avatar_rect.position.x - _x_indent - _card_size.x
	for i in range(_avatar_id - 1, -1, -1):
		_cards[i].set_position(Vector2(x1, _margin.position.y))
		x1 -= offset

func casting_on(card_id: int, is_right: bool):
#	aligment()
	var offset := _card_size.x + _x_indent
	if is_right:
		#check _cards.size != 0
		print("do")
		var card: Card = get_card(card_id)
#		if has_card(card_id):
		if card:
			print("has_do")
			var x := card.position().x
	#		var x := avatar._rect.end.x + _x_indent
	#		x += offset * card_id
			for i in range(card_id, card_count()):
				x += offset
				_cards[i].set_position(Vector2(x, _margin.position.y))
	else:
		#check _cards.size != 0
		var card: Card = get_card(card_id)
#		if has_card(card_id):
		if card:
			var x := card.position().x
	#		var x := avatar._rect.position.x - _x_indent - _card_size.x
	#		x -= offset * card_id
			for i in range(card_id, -1, -1):
				x -= offset
				_cards[i].set_position(Vector2(x, _margin.position.y))

func input(sense: Sense):
	if sense.dragging():
		dragging(sense)
	else:
#					var is_right := tabel.has_right_side(mouse_pos)
#					# if casting change type check card position evaible
#					#if card_id >= avatar_id = is_right
		var card_id := has_point_on_card(sense.mouse_pos())
		sense.set_card_id(card_id)
		sense.set_view_id(_id)
	
#	if sense.clicked():
		
#		sense.input_event(MouseEnter, Tabel, player_id, card_id, can_drag)
#func has_right_side(point: Vector2) -> bool:
#	return point.x > _rect.size.x * 0.5
	
func output(sense: Sense):
	aligment()

func dragging(sense: Sense):
#	if targgeting() and player_id != this_player_id():
#	if casting() and player_id == this_player_id() and card_id > -1:
#	tabel.casting_on(card_id, is_right)
	if sense.drag_view_id() == Sense.Hand:
			print("gggg")
			var is_right := has_point_is_right(sense.mouse_pos())
			var card_id := has_point_on_cast(sense.mouse_pos())
			sense.set_is_right(is_right)
			sense.set_card_id(card_id)
			sense.set_view_id(_id)
			casting_on(card_id, is_right)
#	if sense.drag_view_id() == Sense.Tabel:
	pass

func has_point_is_right(point: Vector2) -> bool:
	return _rect.position.x + _rect.size.x * 0.5 < point.x

func has_point_on_card(point: Vector2) -> int:
	var offset := _card_size.x + _x_indent
	if _avatar_rect.has_point(point):
		return _avatar_id
	var pos := Vector2(_avatar_rect.end.x + _x_indent, _margin.position.y)
	for i in range(_avatar_id + 1, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += offset
	pos = Vector2(_avatar_rect.position.x - _x_indent - _card_size.x, _margin.position.y)
	for i in range(_avatar_id - 1, -1, -1):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x -= offset
	return -1

func has_point_on_cast(point: Vector2) -> int:
	var line_center_x := _rect.position.x + _rect.size.x * 0.5
	var is_right := line_center_x < point.x
	var offset := _card_size.x + _x_indent
	var pos := Vector2(line_center_x, _margin.position.y)
	if is_right:
		for i in range(_avatar_id + 1, card_count() + 1):
			if Rect2(pos, _card_size).has_point(point):
				return i
			pos.x += offset
	else:
		for i in range(_avatar_id, -1, -1):
			if Rect2(pos, _card_size).has_point(point):
				return i
			pos.x -= offset
	return -1

func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	draw_card(ctx, _cards[_avatar_id], _avatar_rect.size, _avatar_pivot)
	for i in range(_avatar_id + 1, card_count()):
		draw_card(ctx, _cards[i], _card_size, _card_pivot)
	for i in range(_avatar_id - 1, -1, -1):
		draw_card(ctx, _cards[i], _card_size, _card_pivot)
#	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
#	avatar.draw(ctx, font)

func draw_card(ctx: CanvasItem, card: Card, card_size: Vector2, card_pivot: Vector2):
	if card.visible():
		var font: DynamicFont = ctx.font
	#	var _pivot := size * 0.5 * _scale
#		ctx.draw_set_transform(card.position + _card_pivot, card.rotation, card.scale)
#		ctx.draw_texture_rect(_texture, Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
		ctx.draw_texture_rect(card.texture(), Rect2(card.position(), card_size), false)
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.draw_string(font, card.position() - Vector2(0, 16), "Bill Amstrong")
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color(255, 0 ,0))
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color(219, 172 ,0))
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color(163, 0 ,242))
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.draw_string(font, card.position() - Vector2(0, 16), "3000")
		if card.highlight():
			ctx.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), card.hightlight_color(), false, 30)

