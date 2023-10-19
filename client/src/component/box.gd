extends Object
class_name Box

enum { FirstHSplit, SecondHSplit, FirstVSplit, SecondVSplit, 
	Center, LeftCenter, RightCenter, TopCenter, BottomCenter, 
	LeftTop, LeftBottom, RightTop, RightBottom }
var _rect: Rect2
var _padding: Rect2
var _focused := false
var _clicked := false
var _dragging := false
var _targeting := false
var _hovered := false
var _visible := true
#var _active := true

func init(pos: Vector2, size: Vector2) -> void:
	_rect = Rect2(pos, size)

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
	return Sense.None

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

func expand(to: Vector2) -> void:
	_rect = _rect.expand(to)

func set_hovered(hovered: bool) -> void:
	_hovered = hovered

func set_visible(visible: bool) -> void:
	_visible = visible

#func draw(ctx: CanvasItem) -> void:
##	if _texture:
#	ctx.draw_texture_rect(_texture, _rect, false)
#	if _highlight:
#		ctx.draw_rect(_rect, _highlight_color, false, 30)
##		_highlight = false

#func set_position(pos: Vector2) -> void:
#	_rect.position = pos
#
#func position() -> Vector2:
#	return _rect.position
#
#func _mouse_enter(sense: Sense) -> bool:
#	if _rect.has_point(sense.mouse_pos()):
#		if sense.targeting():
#			targeting(sense)
#		if sense.dragging():
#			dragging(sense)
#		else:
#			input(sense)
#			hovered(sense)
#		return true
#	return false

#func _mouse_exit(sense: Sense) -> void:
#	output(sense)
#	unhovered(sense)

#func input(sense: Sense) -> void:
#	pass
#
#func dragging(sense: Sense) -> void:
#	pass
#
#func targeting(sense: Sense) -> void:
#	pass
#
#func output(sense: Sense) -> void:
#	pass
#
#func hovered(sense: Sense) -> void:
##	sense.set_hovered(true)
#	set_highlight(true, (Color.red if sense.clicked() else Color.yellow))
#
#func unhovered(sense: Sense) -> void:
##	sense.set_hovered(false)
#	set_highlight(false)

#func set_highlight(highlight: bool = true, color: Color = Color.aqua) -> void:
#	_highlight_color = color
#	_highlight = highlight
#
#func highlight() -> bool:
#	return _highlight
#
#func highlight_color() -> Color:
#	return _highlight_color
#
#func draw(ctx: CanvasItem) -> void:
##	if _texture:
#	ctx.draw_texture_rect(_texture, _rect, false)
#	if _highlight:
#		ctx.draw_rect(_rect, _highlight_color, false, 30)
##		_highlight = false

#func init_from(
#	type: int, 
#	size: Vector2 = Vector2.ZERO, 
#	margin: float = 0,
#	box: Box = Box.new()
#) -> Box:
#	match type:
#		FirstHSplit:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			p_size.y *= 0.5
#			box.init(p_pos, p_size)
#			return box
#		SecondHSplit:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			p_size.y *= 0.5
#			p_pos.y += p_size.y
#			box.init(p_pos, p_size)
#			return box
#		FirstVSplit:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			p_size.x *= 0.5
#			box.init(p_pos, p_size)
#			return box
#		SecondVSplit:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			p_size.x *= 0.5
#			p_pos.x += p_size.x
#			box.init(p_pos, p_size)
#			return box
#		Center:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.y += (p_size.y - size.y) * 0.5
#			p_pos.x += (p_size.x - size.x) * 0.5
#			box.init(p_pos, size)
#			return box
#		LeftCenter:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.y += (p_size.y - size.y) * 0.5
#			p_pos.x += margin
#			box.init(p_pos, size)
#			return box
#		RightCenter:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.y += (p_size.y - size.y) * 0.5
#			p_pos.x += p_size.x - size.x - margin
#			box.init(p_pos, size)
#			return box
#		TopCenter:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.y += margin
#			p_pos.x += (p_size.x - size.x) * 0.5
#			box.init(p_pos, size)
#			return box
#		BottomCenter:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.y += p_size.y - size.y - margin
#			p_pos.x += (p_size.x - size.x) * 0.5
#			box.init(p_pos, size)
#			return box
#		LeftTop:
#			var p_pos := _rect.position
#			assert(size != Vector2.ZERO)
#			p_pos.x += margin
#			p_pos.y += margin
#			box.init(p_pos, size)
#			return box
#		LeftBottom:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.y += p_size.y - size.y - margin
#			p_pos.x += margin
#			box.init(p_pos, size)
#			return box
#		RightTop:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.x += p_size.x - size.x - margin
#			p_pos.y += margin
#			box.init(p_pos, size)
#			return box
#		RightBottom:
#			var p_pos := _rect.position
#			var p_size := _rect.size
#			assert(size != Vector2.ZERO)
#			p_pos.x += p_size.x - size.x - margin
#			p_pos.y += p_size.y - size.y - margin
#			box.init(p_pos, size)
#			return box
#		_: return null

