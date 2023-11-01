extends Object
class_name Component

enum { Custom, TopHSplit, BottomHSplit, LeftVSplit, RightVSplit, 
	Center, CenterLeft, CenterRight, CenterTop, CenterBottom, 
	TopLeft, TopRight, BottomLeft, BottomRight, Padding,
	MarginLeft, MarginRight, MarginTop, MarginBottom }
#global
#var _transform: Transform2D = Transform2D.IDENTITY
var _position: Vector2 = Vector2.ZERO
var _rotation: float = 0
var _scale: Vector2 = Vector2.ONE
##local
var _rect: Rect2 #= Rect2(-Vector2(100, 100), Vector2(200, 200)) #-pivot, size
var _padding: Vector2 = Vector2.ZERO

var _visible := true
var _mouse_enter := false
var _mouse_hover := false
var _mouse_exit := false
var _mouse_click := false

#var animation: CompAnimation = CompAnimation.new()

var _clicked := false
var _dragging := false
var _targeting := false
var _hovered := false
#var _focused := false
#var _visible := true
#var _active := true

func _init(
	ctx: Context,
	parent: Component = null,
	relative_type: int = Custom, #Component.TopLeft
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = Vector2.ZERO
) -> void:
	if not parent:
		#todo
		if custom_size == Vector2.ZERO:
			custom_size = Vector2(200, 200)
		set_transform(offset, custom_size, 0)
		return
	var pos: Vector2 = parent.position()
	var rotation: float = parent.rotation()
	var size: Vector2 = parent.size()
	if custom_size == Vector2.ZERO:
		custom_size = parent.size() 
	match relative_type:
		Custom:
			pos = offset
			set_transform(pos, size, rotation)
		TopHSplit:
			size.y *= 0.5
			pos += offset
			size -= offset * 2
			set_transform(pos, size, rotation)
		BottomHSplit:
			size.y *= 0.5
			pos.y += size.y
			pos += offset
			size -= offset * 2
			set_transform(pos, size, rotation)
		LeftVSplit:
			size.x *= 0.5
			pos += offset
			size -= offset * 2
			set_transform(pos, size, rotation)
		RightVSplit:
			size.x *= 0.5
			pos.x += size.x
			pos += offset
			size -= offset * 2
			set_transform(pos, size, rotation)
		Center:
			pos.x += (size.x - custom_size.x) * 0.5
			pos.y += (size.y - custom_size.y) * 0.5
			pos += offset
			custom_size -= offset * 2
			set_transform(pos, custom_size, rotation)
		CenterLeft:
			pos.x += offset.x
			pos.y += (size.y - custom_size.y) * 0.5
			set_transform(pos, custom_size, rotation)
		CenterRight:
			pos.x += size.x - custom_size.x - offset.x
			pos.y += (size.y - custom_size.y) * 0.5
			set_transform(pos, custom_size, rotation)
		CenterTop:
			pos.x += (size.x - custom_size.x) * 0.5
			pos.y += offset.y
			set_transform(pos, custom_size, rotation)
		CenterBottom:
			pos.y += size.y - custom_size.y - offset.x
			pos.x += (size.x - custom_size.x) * 0.5
			set_transform(pos, custom_size, rotation)
		TopLeft:
			pos += offset
			set_transform(pos, custom_size, rotation)
		BottomLeft:
			pos.x += offset.x
			pos.y += size.y - custom_size.y - offset.y
			set_transform(pos, custom_size, rotation)
		TopRight:
			pos.x += size.x - custom_size.x - offset.x
			pos.y += offset.y
			set_transform(pos, custom_size, rotation)
		BottomRight:
			pos.x += size.x - custom_size.x - offset.x
			pos.y += size.y - custom_size.y - offset.y
			set_transform(pos, custom_size, rotation)
		Padding:
			pos += offset
			size -= offset * 2
			set_transform(pos, size, rotation)
		MarginLeft:
			pos.x -= (size.x + offset.x)
			set_transform(pos, custom_size, rotation)
		MarginRight:
			pos.x += (size.x + offset.x)
			set_transform(pos, custom_size, rotation)
		MarginTop:
			pos.y -= (size.y + offset.y)
			set_transform(pos, custom_size, rotation)
		MarginBottom:
			pos.y += (size.y + offset.y)
			set_transform(pos, custom_size, rotation)

func render(ctx: Context) -> void:
	pass

func input(ctx: Context) -> void:
	if _visible:
		var s = sin(-_rotation)
		var c = cos(-_rotation)
		var point := ctx.mouse_pos() - center()
		point = Vector2(point.x * c - point.y * s, point.x * s + point.y * c) + center()
		
		if rect_has_point(point):
			if _mouse_enter:
				_mouse_enter = false
				_mouse_hover = true
			else:
				_mouse_enter = true
			if ctx.clicked():
				_mouse_click = true
		elif _mouse_enter or _mouse_hover:
			_mouse_enter = false
			_mouse_hover = false
			_mouse_exit = true
		elif _mouse_exit:
			_mouse_exit = false

func has_input() -> bool:
	return _mouse_enter or _mouse_hover or _mouse_exit

func set_transform(position: Vector2, size: Vector2, rotation: float = 0) -> void:
	_position = position
#	_size = size
#	_pivot = _size * 0.5
	_rect = Rect2(-size * 0.5, size)
	_rotation = rotation

func set_position(position: Vector2) -> void:
	_position = position

func position() -> Vector2:
	return _position

func set_rotation(rotation: float) -> void:
	_rotation = rotation

func rotation() -> float:
	return _rotation

func set_scale(scale: Vector2) -> void:
#	_rect = Rect2(-_rect.size * 0.5 * scale, _rect.size * 0.5 * scale)
	_rect.position *= scale
	_rect.size *= scale
	_scale = scale

func scale() -> Vector2:
	return _scale

func set_size(size: Vector2) -> void:
#	_size = size 
#	_pivot = _size * 0.5
	_rect = Rect2(-size * 0.5, size)

func size() -> Vector2:
	return _rect.size

func set_pivot(pivot: Vector2) -> void:
#	_size = size 
#	_pivot = _size * 0.5
	_rect.position = pivot

func pivot() -> Vector2:
	return -_rect.position

func center() -> Vector2:
	return _position + (-_rect.position)

func rect() -> Rect2:
	return _rect

#global
func content_rect() -> Rect2:
	return Rect2(_position + _padding, _rect.size - _padding * 2)

func set_visible(visible: bool) -> void:
	_visible = visible

func visible() -> bool:
	return _visible

func set_padding(padding: Vector2) -> void:
	_padding = padding

func padding() -> Vector2:
	return _padding

func mouse_enter() -> bool:
	return _mouse_enter

func mouse_hover() -> bool:
	return _mouse_hover

func mouse_exit() -> bool:
	return _mouse_exit

func mouse_click() -> bool:
	return _mouse_click



func is_hovered() -> bool:
	return _hovered

func is_clicked() -> bool:
	return _clicked

func is_dragging() -> bool:
	return _dragging

func is_targeting() -> bool:
	return _targeting

#func set_hovered(hovered: bool) -> void:
#	_hovered = hovered

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

#static func rect_has_point(pos: Vector2, size: Vector2, p: Vector2):
#	if p.x < pos.x:
#		return false
#	if p.y < pos.y:
#		return false
#	if p.x >= (pos.x + size.x):
#		return false
#	if p.y >= (pos.y + size.y):
#		return false
#	return true

func rect_has_point(point: Vector2):
	var size: Vector2 = size()
	if point.x < _position.x:
		return false
	if point.y < _position.y:
		return false
	if point.x >= (_position.x + size.x):
		return false
	if point.y >= (_position.y + size.y):
		return false
	return true
