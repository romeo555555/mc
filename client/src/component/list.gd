extends Object
class_name List

var _capacity: int
var _list: Array
enum Aligment { Left, Right, Center, Bent, Grid }
var _aligment: int = 0
var _row_capacity: int
var _miroring := false
var _rect: Rect2
var _min_angel: float = -0.35
var _max_angel: float = 0.35
var _x_offset: float = 0.0
var _x_indent: float = 0.0
var _card_size: Vector2

var _focused_card_id: int = -1

var _cached_card_id: int
var _cached_card_pos: Vector2
var _cached_card_rot: float

func set_rect(rect: Rect2) -> void:
	_rect = rect

func set_angel(min_angel: float = -0.35, max_angel: float = 0.35) -> void:
	_min_angel = min_angel
	_max_angel = max_angel

func set_card_size(x_card_aspect: float, x_card_indent: float) -> void:
	_card_size = Vector2(_rect.size.y * x_card_aspect, _rect.size.y)
	_x_indent = x_card_indent
	_x_offset = _x_indent + _card_size.x

func card_size() -> Vector2:
	return _card_size

func set_aligment(aligment: int) -> void:
	_aligment = aligment

func aligment() -> int:
	return _aligment

func set_miroring(miroring: bool) -> void:
	_miroring = miroring

func miroring() -> bool:
	return _miroring

func set_row_capacity(count: int) -> void:
	_row_capacity = count

func set_capacity(count: int) -> void:
	_capacity = count

func capacity() -> int:
	return _capacity

func size() -> int:
	return _list.size()

func is_full() -> bool:
	return _list.size() == _capacity

func is_empety() -> bool:
	return _list.size() == 0

func add_card(card: Card, idx: int = -1) -> void:
	card.set_rotation(0)
	if idx > -1:
		_list.insert(idx, card)
	else:
		_list.push_back(card)
	aligment_line()

func get_card(idx: int) -> Card:
	if idx > -1: 
		return _list[idx]
	else:
		return null

func remove_card(idx: int) -> Card:
	var card: Card = _list.pop_at(idx)
#	aligment_line()
	return card

func aligment_line() -> void:
	match _aligment:
		Aligment.Left:
			var pos := _rect.position\
				+ Vector2(_card_size.x * 0.5 - _x_indent, 0)
			for i in range(0, size()):
				_list[i].set_position(pos)
				pos.x += _x_offset
		Aligment.Right:
			var pos := _rect.position + Vector2(_rect.size.x - _card_size.x, 0)\
				- Vector2(_card_size.x * 0.5 - _x_indent, 0)
			for i in range(0, size()):
				_list[i].set_position(pos)
				pos.x -= _x_offset
		Aligment.Center:
			var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1)
			var pos := Vector2(_rect.position.x + (_rect.size.x - lenght_x) * 0.5, _rect.position.y)
#			\
#				- Vector2(_card_size.x * 0.5 - _x_indent, 0)
			for i in range(0, size()):
				_list[i].set_position(pos)
				pos.x += _x_offset
		Aligment.Grid:
			#	var pos := _start_pos
			var pos := _rect.position
#				\ + Vector2(_card_size.x * 0.5 - _x_indent, 0)
			var row := 0
			for i in range(0, size()):
				var colum := int(i) % _row_capacity
				_list[i].set_position(pos)
				_list[i].set_rotation(0)
				pos.x += _x_offset
				if colum == 4:
					row += 1
					pos.y += _x_offset
#			rect_min_size = _cards[card_count()-1].position() + _card_size + _indent + Vector2(0, _margin_offset.y)
#			box.init(box.position(), Vector2(box.size().x, rect_min_size.y + _margin_offset.y))
		Aligment.Bent:
			var count := float(size())
			
			if count < 4:
				var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1)
				var pos := Vector2(_rect.position.x + (_rect.size.x - lenght_x) * 0.5, _rect.position.y)\
					- Vector2(_card_size.x * 0.5 + _x_indent, 0)
				for i in range(0, size()):
					_list[i].set_position(pos)
					pos.x += _x_offset
				return
			
			var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1) - _card_size.x
			var pos := Vector2(_rect.position.x + (_rect.size.x - lenght_x) * 0.5, _rect.position.y)\
				- Vector2(_card_size.x * 0.5 , 0)
			var end := pos + Vector2(lenght_x, 0)
			var curve := Curve2D.new()
			if _miroring:
				pos.y += 200
				end.y += 200
				curve.add_point(pos, Vector2(-122, 243), Vector2(122, -243))
				curve.add_point(end, Vector2(-122, -243), Vector2(122, 243))
			else:
				pos.y -= 200
				end.y -= 200
				curve.add_point(end, Vector2(-122, -243), Vector2(122, 243))
				curve.add_point(pos, Vector2(-122, 243), Vector2(122, -243))
			
			var offs_i := 0.0 if size() % 2 == 0 else 0.5
			for i in range(0, count):
				var t := float(i+offs_i) / count
				var angel: float = lerp(_min_angel, _max_angel, t)
				var card = _list[i]
				card.set_position(curve.interpolate_baked(t * curve.get_baked_length(), false))
				card.set_rotation(angel)

func focused_card(point: Vector2) -> bool:
	var pos := _rect.position
	match _aligment:
		Aligment.Left: pos += Vector2(_card_size.x * 0.5 - _x_indent, 0)
		Aligment.Right: 
			pos += Vector2(_rect.size.x - _card_size.x, 0)\
				- Vector2(_card_size.x * 0.5 - _x_indent, 0)
			for i in range(0, size()):
				if Rect2(pos, _card_size).has_point(point):
					_focused_card_id = i
					return true
				pos.x -= _x_offset
			_focused_card_id = -1
			return false
		Aligment.Center:
			var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1)
#			pos.x += (_rect.size.x - lenght_x) * 0.5
			pos += Vector2((_rect.size.x - lenght_x) * 0.5, 0)
#				\
#				- Vector2(_card_size.x * 0.5 - _x_indent, 0)
		Aligment.Bent:
			var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1)
#			pos.x += (_rect.size.x - lenght_x) * 0.5
			pos += Vector2((_rect.size.x - lenght_x) * 0.5, 0)\
				- Vector2(_card_size.x * 0.5 - _x_indent, 0)
#			if size() > 4:
			for i in range(0, size()):
				var card: Card = _list[i]
				if card.visible():
					var card_pivot := _card_size * 0.5
					var s = sin(-card.rotation())
					var c = cos(-card.rotation())
					
					var new_point := point - (card.position() + card_pivot)
					new_point = Vector2(new_point.x * c - new_point.y * s, new_point.x * s + new_point.y * c)
					new_point = new_point + card.position() + card_pivot
					if Rect2(card.position(), _card_size).has_point(new_point):
						_focused_card_id = i
						return true
			_focused_card_id = -1
			return false
	for i in range(0, size()):
		if Rect2(pos, _card_size).has_point(point):
			_focused_card_id = i
			return true
		pos.x += _x_offset
	_focused_card_id = -1
	return false

func get_focused_card() -> Card:
	return _list[_focused_card_id]

func get_focused_card_id() -> int:
	return _focused_card_id

func has_focused_card() -> bool:
	return _focused_card_id > -1

func unfocused_card() -> void:
	_focused_card_id = -1

func casting(point: Vector2) -> void:
	var pos := _rect.position # center_tabel
	var margin_x := _x_indent + _card_size.x * 0.5
	match _aligment :
		Aligment.Left: pos.x -= margin_x
		Aligment.Right: pos.x += _rect.size.x + margin_x
		Aligment.Center:
			var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1)
			pos.x += (_rect.size.x - lenght_x) * 0.5 + margin_x
		Aligment.Bent:
			#error
			var lenght_x := _card_size.x * float(size()) + _x_indent * float(size() - 1)
			pos.x += (_rect.size.x - lenght_x) * 0.5 + margin_x
	for i in range(0, size()):
		if Rect2(pos, _card_size).has_point(point):
#			aligment_line()
			var card: Card = get_card(i)
			if card:
				var card_pos := card.position()
				for j in range(i, size()):
					card_pos.x += _x_offset
					_list[j].set_position(card_pos)
			_focused_card_id = i
			return
		pos.x += _x_offset
	_focused_card_id = -1

func cached_card(card_id: int) -> void:
	var card: Card = _list[card_id]
	_cached_card_id = card_id
	_cached_card_pos = card.position()
	_cached_card_rot = card.rotation()
#	card.set_visible(false)
#	card.set_rotation(0)
#	card.set_scale(Vector2.ONE)

func get_cached_card() -> Card:
	return get_card(_cached_card_id)

func uncached_card() -> void:
	var card: Card = _list[_cached_card_id]
	card.set_visible(true)
	card.set_position(_cached_card_pos)
	card.set_rotation(_cached_card_rot)
	card.set_scale(Vector2.ONE)

func remove_cached_card() -> Card:
	return remove_card(_cached_card_id)
