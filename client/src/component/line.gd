extends Component
class_name Line

var _max_size_line := 4
var _center_tabel: Vector2
var _start_pos: Vector2
var _x_indent: float
var _x_offset: float
#var _miroring := false
var _cards: Array
var _card_size := Vector2.ZERO

func init_right(pos: Vector2, size: Vector2, card_size: Vector2, x_indent: float):
	_center_tabel = Vector2(pos.x + x_indent, pos.y + (size.y - card_size.y) * 0.5)
	_start_pos = Vector2(_center_tabel.x + card_size.x * 0.5 + x_indent, _center_tabel.y)
	_x_offset = card_size.x + x_indent
	_card_size = card_size
	_x_indent = x_indent
	_rect = Rect2(pos, size)

func init_left(pos: Vector2, size: Vector2, card_size: Vector2, x_indent: float):
	_center_tabel = Vector2(pos.x + size.x - card_size.x - card_size.x * 0.5 - x_indent, 
	 pos.y + (size.y - card_size.y) * 0.5)
	_start_pos = Vector2(_center_tabel.x - x_indent, _center_tabel.y)
	_x_offset = -1 * (card_size.x + x_indent)
	_card_size = card_size
	_x_indent = x_indent
	_rect = Rect2(pos, size)

func card_count() -> int:
	return _cards.size()

func is_full(is_right: bool) -> bool:
	return card_count() == _max_size_line

func is_empety() -> bool:
	return _cards.size() == 0

func add_card(card: Card, idx: int = -1):
	card.set_rotation(0)
	if idx > -1:
		_cards.insert(idx, card)
	else:
		_cards.push_back(card)
	aligment()
#		var x := avatar._rect.end.x + _x_indent \
#			+ (_card_size.x + _x_indent) * _right_count
#		card.set_position(Vector2(x, _margin.position.y))
#		card.set_rotation(0)
#		_cards.push_back(card)

#		var x := avatar._rect.position.x - _x_indent \
#		 - _card_size.x - (_card_size.x + _x_indent) * _left_count
#		_cards.push_front(card)
#		card.set_position(Vector2(x, _margin.position.y))
#		card.set_rotation(0)

func get_card(card_id: int) -> Card:
	if card_id > -1: 
#	and _cards.has(card_id):
		return _cards[card_id]
	else:
		return null

func remove_card(idx: int) -> Card:
	return _cards.pop_at(idx)

func has_point_on_card(point: Vector2) -> int:
#	var pos := Vector2(_avatar_rect.end.x + _x_indent, _margin.position.y)
	var pos := _start_pos
	for i in range(0, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += _x_offset
	return -1
	
#	var offset := _card_size.x + _x_indent
#	if _avatar_rect.has_point(point):
#		return _avatar_id
#	var pos := Vector2(_avatar_rect.end.x + _x_indent, _margin.position.y)
#	for i in range(_avatar_id + 1, card_count()):
#		if Rect2(pos, _card_size).has_point(point):
#			return i
#		pos.x += offset
#	pos = Vector2(_avatar_rect.position.x - _x_indent - _card_size.x, _margin.position.y)
#	for i in range(_avatar_id - 1, -1, -1):
#		if Rect2(pos, _card_size).has_point(point):
#			return i
#		pos.x -= offset
#	return -1

func has_point_on_cast(point: Vector2) -> int:
	var pos := _center_tabel
	for i in range(0, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += _x_offset
	return -1
#	var line_center_x := _rect.position.x + _rect.size.x * 0.5
#	var is_right := line_center_x < point.x
#	var offset := _card_size.x + _x_indent
#	var pos := Vector2(line_center_x, _margin.position.y)
#	if is_right:
#		for i in range(_avatar_id + 1, card_count() + 1):
#			if Rect2(pos, _card_size).has_point(point):
#				return i
#			pos.x += offset
#	else:
#		for i in range(_avatar_id, -1, -1):
#			if Rect2(pos, _card_size).has_point(point):
#				return i
#			pos.x -= offset
#	return -1

func aligment():
	var pos := _start_pos
	for i in range(0, card_count()):
		_cards[i].set_position(pos)
		pos.x += _x_offset
#	var offset := _card_size.x + _x_indent
#	if is_right:
#	var x := _avatar_rect.end.x + _x_indent
#	for i in range(_avatar_id + 1, card_count()):
#		print(i)
#		_cards[i].set_position(Vector2(x, _margin.position.y))
#		x += offset
##	else:
#	var x1 := _avatar_rect.position.x - _x_indent - _card_size.x
#	for i in range(_avatar_id - 1, -1, -1):
#		_cards[i].set_position(Vector2(x1, _margin.position.y))
#		x1 -= offset

func casting_on(card_id: int):
#	aligment()
	var card: Card = get_card(card_id)
	if card:
		var pos := card.position()
		for i in range(card_id, card_count()):
			pos.x += _x_offset
			_cards[i].set_position(pos)
##	aligment()
#	var offset := _card_size.x + _x_indent
#	if is_right:
#		#check _cards.size != 0
#		print("do")
#		var card: Card = get_card(card_id)
##		if has_card(card_id):
#		if card:
#			print("has_do")
#			var x := card.position().x
#	#		var x := avatar._rect.end.x + _x_indent
#	#		x += offset * card_id
#			for i in range(card_id, card_count()):
#				x += offset
#				_cards[i].set_position(Vector2(x, _margin.position.y))
#	else:
#		#check _cards.size != 0
#		var card: Card = get_card(card_id)
##		if has_card(card_id):
#		if card:
#			var x := card.position().x
#	#		var x := avatar._rect.position.x - _x_indent - _card_size.x
#	#		x -= offset * card_id
#			for i in range(card_id, -1, -1):
#				x -= offset
#				_cards[i].set_position(Vector2(x, _margin.position.y))

func input(sense: Sense):
#		var is_right := tabel.has_right_side(mouse_pos)
#		#if casting change type check card position evaible
#		#if card_id >= avatar_id = is_right
	var card_id := has_point_on_card(sense.mouse_pos())
	sense.set_card_id(card_id)
#	if sense.clicked():
#		sense.input_event(MouseEnter, Tabel, player_id, card_id, can_drag)
#func has_right_side(point: Vector2) -> bool:
#	return point.x > _rect.size.x * 0.5

func output(sense: Sense):
	pass

func dragging(sense: Sense):
	#	if targgeting() and player_id != this_player_id():
#	if casting() and player_id == this_player_id() and card_id > -1:
#	tabel.casting_on(card_id, is_right)
	if sense.drag_view_id() == Sense.Hand:
		var card_id := has_point_on_cast(sense.mouse_pos())
		sense.set_card_id(card_id)
		casting_on(card_id)
#	if sense.drag_view_id() == Sense.Tabel:

func draw(ctx: CanvasItem):
	for card in _cards:
		ctx.draw_tabel_card(card, _card_size)
