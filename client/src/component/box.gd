extends Object
class_name Box

enum { TopHSplit, BottomHSplit, LeftVSplit, RightVSplit, 
	Center, CenterLeft, CenterRight, CenterTop, CenterBottom, 
	TopLeft, TopRight, BottomLeft, BottomRight, Padding,
	MarginLeft, MarginRight, MarginTop, MarginBottom }
var _rect: Rect2
var _focused := false

var _padding: Vector2
var _content: Rect2 #get_content_rect

var _clicked := false
var _dragging := false
var _targeting := false
var _hovered := false
var _visible := true
#var _active := true

func set_rect(rect: Rect2) -> void:
	_rect = rect

#func has_point(sense: Sense) -> bool:
#	return _rect.has_point(sense.mouse_pos())

func input(sense: Sense) -> int:
	if _visible:
		_clicked = sense.clicked()
		_dragging = sense.dragging()
		_targeting = sense.targeting()
		if sense.selected() or not _rect.has_point(sense.mouse_pos()):
			if _focused:
				_focused = false
				return Sense.Exit
		else:
			sense.selecting()
			_focused = true
			if _clicked:
				return Sense.Click
			return Sense.Enter
	
	return Sense.ClickOutside if _clicked else Sense.None


func is_focused() -> bool:
	return _focused

func is_hovered() -> bool:
	return _hovered

func is_clicked() -> bool:
	return _clicked

func is_dragging() -> bool:
	return _dragging

func is_targeting() -> bool:
	return _targeting

func is_visible() -> bool:
	return _visible

func position() -> Vector2:
	return _rect.position

func size() -> Vector2:
	return _rect.size

func rect() -> Rect2:
	return _rect

func center() -> Vector2:
	return _rect.get_center()

func expand(to: Vector2) -> void:
	_rect = _rect.expand(to)

func set_hovered(hovered: bool) -> void:
	_hovered = hovered

func set_visible(visible: bool) -> void:
	_visible = visible

#func set_position(pos: Vector2) -> void:
#	_rect.position = pos

#func set_highlight(highlight: bool = true, color: Color = Color.aqua) -> void:
#	_highlight_color = color
#	_highlight = highlight
#
#func highlight() -> bool:
#	return _highlight
#
#func highlight_color() -> Color:
#	return _highlight_color

func relative_rect(
	type: int, 
	offset: float = 0,
	custom_size: Vector2 = _rect.size
) -> Rect2:
	match type:
		TopHSplit:
			var pos := _rect.position
			var size := _rect.size
			size.y *= 0.5
			pos += Vector2(offset, offset)
			size -= Vector2(offset, offset) * 2
			return Rect2(pos, size)
		BottomHSplit:
			var pos := _rect.position
			var size := _rect.size
			size.y *= 0.5
			pos.y += size.y
			pos += Vector2(offset, offset)
			size -= Vector2(offset, offset) * 2
			return Rect2(pos, size)
		LeftVSplit:
			var pos := _rect.position
			var size := _rect.size
			size.x *= 0.5
			pos += Vector2(offset, offset)
			size -= Vector2(offset, offset) * 2
			return Rect2(pos, size)
		RightVSplit:
			var pos := _rect.position
			var size := _rect.size
			size.x *= 0.5
			pos.x += size.x
			pos += Vector2(offset, offset)
			size -= Vector2(offset, offset) * 2
			return Rect2(pos, size)
		Center:
			var pos := _rect.position
			var size := _rect.size
			pos.x += (size.x - custom_size.x) * 0.5
			pos.y += (size.y - custom_size.y) * 0.5
			pos += Vector2(offset, offset)
			size -= Vector2(offset, offset) * 2
			return Rect2(pos, custom_size)
		CenterLeft:
			var pos := _rect.position
			var size := _rect.size
			pos.x += offset
			pos.y += (size.y - custom_size.y) * 0.5
			return Rect2(pos, custom_size)
		CenterRight:
			var pos := _rect.position
			var size := _rect.size
			pos.x += size.x - custom_size.x - offset
			pos.y += (size.y - custom_size.y) * 0.5
			return Rect2(pos, custom_size)
		CenterTop:
			var pos := _rect.position
			var size := _rect.size
			pos.x += (size.x - custom_size.x) * 0.5
			pos.y += offset
			return Rect2(pos, custom_size)
		CenterBottom:
			var pos := _rect.position
			var size := _rect.size
			pos.y += size.y - custom_size.y - offset
			pos.x += (size.x - custom_size.x) * 0.5
			return Rect2(pos, custom_size)
		TopLeft:
			var pos := _rect.position
			var size := _rect.size
			pos.x += offset
			pos.y += offset
			return Rect2(pos, custom_size)
		BottomLeft:
			var pos := _rect.position
			var size := _rect.size
			pos.y += size.y - custom_size.y - offset
			pos.x += offset
			return Rect2(pos, custom_size)
		TopRight:
			var pos := _rect.position
			var size := _rect.size
			pos.x += size.x - custom_size.x - offset
			pos.y += offset
			return Rect2(pos, custom_size)
		BottomRight:
			var pos := _rect.position
			var size := _rect.size
			pos.x += size.x - custom_size.x - offset
			pos.y += size.y - custom_size.y - offset
			return Rect2(pos, custom_size)
		Padding:
			var pos := _rect.position
			var size := _rect.size
			pos += Vector2(offset, offset)
			size -= Vector2(offset, offset) * 2
			return Rect2(pos, size)
		MarginLeft:
			var pos := _rect.position
			var size := _rect.size
			pos.x -= (size.x + offset)
			return Rect2(pos, custom_size)
		MarginRight:
			var pos := _rect.position
			var size := _rect.size
			pos.x += (size.x + offset)
			return Rect2(pos, custom_size)
		MarginTop:
			var pos := _rect.position
			var size := _rect.size
			pos.y -= (size.x + offset)
			return Rect2(pos, custom_size)
		MarginBottom:
			var pos := _rect.position
			var size := _rect.size
			pos.y += (size.y + offset)
			return Rect2(pos, custom_size)
	push_error("Null return rect2")
	return Rect2(Vector2.ZERO, Vector2.ZERO)

