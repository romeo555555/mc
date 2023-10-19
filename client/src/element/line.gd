extends Object
class_name Line

var box: Box = Box.new()
var _max_size_line := 4
var _center_tabel: Vector2
var _start_pos: Vector2
var _x_indent: float
var _x_offset: float
var _miroring := false
var _cards: Array
var _card_size := Vector2.ZERO

var _focused_card_id: int = -1
var _cached_card_id: int
var _cached_card_pos: Vector2
var _cached_card_rot: float

func init_right(miroring: bool, pos: Vector2, size: Vector2, card_size: Vector2, x_indent: float) -> void:
	box.init(pos, size)
	_center_tabel = Vector2(pos.x + x_indent, pos.y + (size.y - card_size.y) * 0.5)
	_start_pos = Vector2(_center_tabel.x + card_size.x * 0.5 + x_indent, _center_tabel.y)
	_x_offset = card_size.x + x_indent
	_card_size = card_size
	_x_indent = x_indent
	_miroring = miroring

func init_left(miroring: bool, pos: Vector2, size: Vector2, card_size: Vector2, x_indent: float) -> void:
	box.init(pos, size)
	_center_tabel = Vector2(pos.x + size.x - card_size.x - card_size.x * 0.5 - x_indent, 
	 pos.y + (size.y - card_size.y) * 0.5)
	_start_pos = Vector2(_center_tabel.x - x_indent, _center_tabel.y)
	_x_offset = -1 * (card_size.x + x_indent)
	_card_size = card_size
	_x_indent = x_indent
	_miroring = miroring

func card_count() -> int:
	return _cards.size()

func is_full(is_right: bool) -> bool:
	return card_count() == _max_size_line

func is_empety() -> bool:
	return _cards.size() == 0

func add_card(card: Card, idx: int = -1) -> void:
	card.set_rotation(0)
	if idx > -1:
		_cards.insert(idx, card)
	else:
		_cards.push_back(card)
	aligment()

func get_card(card_id: int) -> Card:
	if card_id > -1: 
#	and _cards.has(card_id):
		return _cards[card_id]
	else:
		return null

func remove_card(idx: int) -> Card:
	return _cards.pop_at(idx)

func has_point_on_card(point: Vector2) -> int:
	var pos := _start_pos
	for i in range(0, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += _x_offset
	return -1

func has_point_on_cast(point: Vector2) -> int:
	var pos := _center_tabel
	for i in range(0, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += _x_offset
	return -1

func aligment() -> void:
	var pos := _start_pos
	for i in range(0, card_count()):
		_cards[i].set_position(pos)
		pos.x += _x_offset

func casting_on(card_id: int) -> void:
#	aligment()
	var card: Card = get_card(card_id)
	if card:
		var pos := card.position()
		for i in range(card_id, card_count()):
			pos.x += _x_offset
			_cards[i].set_position(pos)

func input(sense: Sense) -> void:
	if box.is_dragging():
		_focused_card_id = has_point_on_cast(sense.mouse_pos())
		casting_on(_focused_card_id)
	elif box.is_targeting():
		pass
	else:
#		box.set_hovered(true)
#	if box.is_clicked():
#		var is_right := tabel.has_right_side(mouse_pos)
#		#if casting change type check card position evaible
#		#if card_id >= avatar_id = is_right
		_focused_card_id = has_point_on_card(sense.mouse_pos())
#	if sense.clicked():
#		sense.input_event(MouseEnter, Tabel, player_id, card_id, can_drag)
#func has_right_side(point: Vector2) -> bool:
#	return point.x > _rect.size.x * 0.5

#func dragging(sense: Sense):
#	#	if targgeting() and player_id != this_player_id():
##	if casting() and player_id == this_player_id() and card_id > -1:
##	tabel.casting_on(card_id, is_right)
#	if sense.drag_view_id() == Sense.Hand:
#		var card_id := has_point_on_cast(sense.mouse_pos())
#		sense.set_card_id(card_id)
#		casting_on(card_id)
##	if sense.drag_view_id() == Sense.Tabel:

func output(sense: Sense) -> void:
#		box.set_hovered(false)
	aligment()
	_focused_card_id = -1
	pass

func focused_card() -> int:
	return _focused_card_id

func cached_card(card_id: int) -> void:
	var card: Card = _cards[card_id]
	_cached_card_id = card_id
	_cached_card_pos = card.position()
	_cached_card_rot = card.rotation()
#	card.set_visible(false)
#	card.set_rotation(0)
#	card.set_scale(Vector2.ONE)

func uncached_card() -> void:
	var card: Card = _cards[_cached_card_id]
	card.set_visible(true)
	card.set_position(_cached_card_pos)
	card.set_rotation(_cached_card_rot)
	card.set_scale(Vector2.ONE)

func get_cached_card() -> Card:
	return get_card(_cached_card_id)

func draw(ctx: CanvasItem) -> void:
	for card in _cards:
		card.draw_on_line(ctx, _card_size)
	#todo
#	if _focused_card_id > -1:
#		if box.is_dragging():
#			pass
#		elif box.is_targeting():
#			if _miroring:
#				pass
#			else:
#				pass
#		else:
#			pass
#	if _cached_card_id > -1:
#		pass
			
	if _focused_card_id > -1:
		var card: Card = _cards[_focused_card_id]
		var box: Box = Box.new()
		box.init(card.position(), _card_size)
		box.set_hovered(true)
		ctx.draw_hovered(box)
