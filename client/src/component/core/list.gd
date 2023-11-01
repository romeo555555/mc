extends Component
class_name List

var _capacity: int
var _list: Array
enum Aligment { Left, Right, Center, Bent, Grid }
var _aligment_type: int = 0
var _miroring := false
var _min_angel: float = -0.35
var _max_angel: float = 0.35
var _x_offset: float = 0.0
var _x_indent: float = 0.0
var _item_size: Vector2

var _focused_item_id: int = -1
var _row_capacity: int = 4

func _init(
	ctx: Context,
	parent: Component,
	relative_type: int = 0,
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = Vector2.ZERO
).(
	ctx,
	parent,
	relative_type,
	offset,
	custom_size
) -> void:
	pass
	
func set_angel(min_angel: float = -0.35, max_angel: float = 0.35) -> void:
	_min_angel = min_angel
	_max_angel = max_angel

func set_item_size(item_size: Vector2, item_indent: Vector2) -> void:
	_item_size = item_size
	_x_indent = item_indent.x
	_x_offset = _x_indent + _item_size.x

func set_item_aspect(x_item_aspect: float, x_item_indent: float = 0) -> void:
	_item_size = Vector2(size().y * x_item_aspect, size().y)
	_x_indent = x_item_indent
	_x_offset = _x_indent + _item_size.x

func item_size() -> Vector2:
	return _item_size

func set_aligment_type(aligment_type: int) -> void:
	_aligment_type = aligment_type

func aligment_type() -> int:
	return _aligment_type

func set_miroring(miroring: bool) -> void:
	_miroring = miroring

func miroring() -> bool:
	return _miroring

func lenght() -> int:
	return _list.size()

#func set_row_capacity(count: int) -> void:
#	_row_capacity = count
#
func set_capacity(count: int) -> void:
	_capacity = count

func capacity() -> int:
	return _capacity

func is_full() -> bool:
	return _list.size() == _capacity

func is_empety() -> bool:
	return _list.size() == 0

func add_item(item: Component, idx: int = -1) -> void:
	item.set_size(_item_size)
	if idx > -1:
		_list.insert(idx, item)
	else:
		_list.push_back(item)
	aligment()

func get_item(idx: int) -> Component:
	if idx > -1: 
		return _list[idx]
	else:
		return null

func get_last_item() -> Component:
	return _list[lenght() - 1]

func swap_item(idx_to: int, idx_from: int) -> void:
	_list.insert(idx_to, _list.pop_at(idx_from))
	
func remove_item(idx: int) -> void:
	_list.remove(idx)

#Swap item witch hide item blank for drop
#remove without return
#cached item perw in board
#aligment when mouse exit not in remove
#func remove_item(idx: int) -> Component:
#	return _list.pop_at(idx)
##	var item: item = _list.pop_at(idx)
###	aligment_line()
##	return item

func aligment() -> void:
	match _aligment_type:
		Aligment.Left:
			var pos := position()\
				+ Vector2(_item_size.x * 0.5 - _x_indent, 0)
			for i in range(0, lenght()):
				_list[i].set_position(pos)
				pos.x += _x_offset
		Aligment.Right:
			var pos := position() + Vector2(size().x - _item_size.x, 0)\
				- Vector2(_item_size.x * 0.5 - _x_indent, 0)
			for i in range(0, lenght()):
				_list[i].set_position(pos)
				pos.x -= _x_offset
		Aligment.Center:
			var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1)
			var pos := Vector2(position().x + (size().x - lenght_x) * 0.5, position().y)
#				\ - Vector2(_item_size.x * 0.5 - _x_indent, 0)
			for i in range(0, lenght()):
				_list[i].set_position(pos)
				pos.x += _x_offset
		Aligment.Grid:
			#	var pos := _start_pos
			var start_pos := position() + Vector2(_x_indent, _x_indent)
			var pos := start_pos
#				\ + Vector2(_item_size.x * 0.5 - _x_indent, 0)
			var row := 0
			for i in range(0, lenght()):
				var colum := i % _row_capacity
				print(colum)
				if colum == 0:
					pos.y = start_pos.y + _x_offset * row
					row += 1
				pos.x = start_pos.x + _x_offset * colum
				_list[i].set_position(pos)
				_list[i].set_rotation(0)
#			rect_min_size = _cards[card_count()-1].position() + _item_size + _indent + Vector2(0, _margin_offset.y)
#			box.init(box.position(), Vector2(box.size().x, rect_min_size.y + _margin_offset.y))
		Aligment.Bent:
			var count := float(lenght())
			
			if count < 4:
				var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1)
				var pos := Vector2(position().x + (size().x - lenght_x) * 0.5, position().y)\
					- Vector2(_item_size.x * 0.5 + _x_indent, 0)
				for i in range(0, lenght()):
					_list[i].set_position(pos)
					pos.x += _x_offset
				return
			
			var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1) - _item_size.x
			var pos := Vector2(position().x + (size().x - lenght_x) * 0.5, position().y)\
				- Vector2(_item_size.x * 0.5 , 0)
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
			
			var offs_i := 0.0 if lenght() % 2 == 0 else 0.5
			for i in range(0, count):
				var t := float(i+offs_i) / count
				var angel: float = lerp(_min_angel, _max_angel, t)
				var item = _list[i]
				item.set_position(curve.interpolate_baked(t * curve.get_baked_length(), false))
				item.set_rotation(angel)

###del
#func focused_item(point: Vector2) -> bool:
#	var pos := _rect.position
#	match _aligment_type:
#		Aligment.Left: pos += Vector2(_item_size.x * 0.5 - _x_indent, 0)
#		Aligment.Right: 
#			pos += Vector2(_rect.size.x - _item_size.x, 0)\
#				- Vector2(_item_size.x * 0.5 - _x_indent, 0)
#			for i in range(0, lenght()):
#				if Rect2(pos, _item_size).has_point(point):
#					_focused_item_id = i
#					return true
#				pos.x -= _x_offset
#			_focused_item_id = -1
#			return false
#		Aligment.Center:
#			var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1)
##			pos.x += (_rect.size.x - lenght_x) * 0.5
#			pos += Vector2((_rect.size.x - lenght_x) * 0.5, 0)
##				\
##				- Vector2(_item_size.x * 0.5 - _x_indent, 0)
#		Aligment.Bent:
#			var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1)
##			pos.x += (_rect.size.x - lenght_x) * 0.5
#			pos += Vector2((_rect.size.x - lenght_x) * 0.5, 0)\
#				- Vector2(_item_size.x * 0.5 - _x_indent, 0)
##			if size() > 4:
#			for i in range(0, lenght()):
#				var item: Card = _list[i]
#				if item.visible():
#					var item_pivot := _item_size * 0.5
#					var s = sin(-item.rotation())
#					var c = cos(-item.rotation())
#
#					var new_point := point - (item.position() + item_pivot)
#					new_point = Vector2(new_point.x * c - new_point.y * s, new_point.x * s + new_point.y * c)
#					new_point = new_point + item.position() + item_pivot
#					if Rect2(item.position(), _item_size).has_point(new_point):
#						_focused_item_id = i
#						return true
#			_focused_item_id = -1
#			return false
#	for i in range(0, lenght()):
#		if Rect2(pos, _item_size).has_point(point):
#			_focused_item_id = i
#			return true
#		pos.x += _x_offset
#	_focused_item_id = -1
#	return false
#
#func get_focused_item() -> Card:
#	return _list[_focused_item_id]
#
#func get_focused_item_id() -> int:
#	return _focused_item_id
#
#func has_focused_item() -> bool:
#	return _focused_item_id > -1
#
#func unfocused_item() -> void:
#	_focused_item_id = -1
#
#func casting(point: Vector2) -> void:
#	var pos := _rect.position # center_tabel
#	var margin_x := _x_indent + _item_size.x * 0.5
#	match _aligment_type :
#		Aligment.Left: pos.x -= margin_x
#		Aligment.Right: pos.x += _rect.size.x + margin_x # -_x_offset!!
#		Aligment.Center:
#			var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1)
#			pos.x += (_rect.size.x - lenght_x) * 0.5 + margin_x
#		Aligment.Bent:
#			#error
#			var lenght_x := _item_size.x * float(lenght()) + _x_indent * float(lenght() - 1)
#			pos.x += (_rect.size.x - lenght_x) * 0.5 + margin_x
#	for i in range(0, lenght()):
#		if Rect2(pos, _item_size).has_point(point):
##			aligment_line()
#			var item: Card = get_item(i)
#			if item:
#				var item_pos := item.position()
#				for j in range(i, lenght()):
#					item_pos.x += _x_offset
#					_list[j].set_position(item_pos)
#			_focused_item_id = i
#			return
#		pos.x += _x_offset
#	_focused_item_id = -1

