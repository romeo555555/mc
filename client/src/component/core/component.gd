extends Object
class_name Component

class Transition:
#	var is_pos := false
	var _position: Vector2
	var _rotation: float
	var _scale: Vector2
	
	func _init(pos: Vector2 = Vector2.ZERO, rot: float = 0, scale: Vector2 = Vector2.ONE) -> void:
		_position = pos
		_rotation = rot
		_scale = scale
	
	func set_position(position: Vector2) -> void:
		_position = position

	func position() -> Vector2:
		return _position

	func set_rotation(rotation: float) -> void:
		_rotation = rotation

	func rotation() -> float:
		return _rotation

	func set_scale(scale: Vector2) -> void:
		_scale = scale

	func scale() -> Vector2:
		return _scale

class CompAnimation:
	var _run: bool
#	var _name: String
#	enum { None, Pos, Rot, Size, PosRot, PosSize, RotSize, PosRotSize }
#	var _animation_type: int = 0 
	var _from: Transition
	var _offset: Transition
	var _to: Transition
#	var _start_frame: float
	var _current_frame: float
	var _duration: float
	enum { Ease, Linear, EaseIn, EaseOut, EaseInOut, CubicBezier} 
	var _timing_func: int
	var _delay: float
	var _iter_count: int
#	var _direction: normal reverse
	
	func set_animation(
		from: Transition,
		to: Transition,
		duration: float,
		timing_func: int
#		delay: float = 0.0
#		iter_count: int = 1
	) -> void:
		_from = from
		_to = to
		_duration = duration
		_timing_func = timing_func
#		_delay = delay
#		_iter_count = iter_count
		_offset = Transition.new(
			_from.position() - _to.position(),
			_from.rotation() - _to.rotation(),
			_from.scale() - _to.scale()
		)
	
	func run() -> void:
		_run = true
	
	func stop() -> void:
		_run = false
	
	func running() -> bool:
		return _run
	
	func step(comp: Component, delta: float) -> void:
		_current_frame += _duration / 100 #delta
#		match _timing_func: 
#		easeInOutQuad
		var i: float = _current_frame < 0.5 if 2 * _current_frame * _current_frame \
			else 1 - pow(-2 * _current_frame + 2, 2) / 2
		comp.set_transform(_offset.position() * i, _offset.scale() * i, _offset.rotation() * i)
		if _current_frame >= _duration:
			stop()

enum { TopHSplit, BottomHSplit, LeftVSplit, RightVSplit, 
	Center, CenterLeft, CenterRight, CenterTop, CenterBottom, 
	TopLeft, TopRight, BottomLeft, BottomRight, Padding,
	MarginLeft, MarginRight, MarginTop, MarginBottom }
#global
#var _transform: Transform2D = Transform2D.IDENTITY
var _position: Vector2 = Vector2.ZERO
var _rotation: float = 0
var _scale: Vector2 = Vector2.ONE
##local
var _rect: Rect2 = Rect2(-Vector2(100, 100), Vector2(200, 200)) #-pivot, size
var _padding: Vector2 = Vector2.ZERO

var _visible := true
var _mouse_enter := false
var _mouse_hover := false
var _mouse_exit := false
var _mouse_click := false

var animation: CompAnimation = CompAnimation.new()

var _clicked := false
var _dragging := false
var _targeting := false
var _hovered := false
#var _focused := false
#var _visible := true
#var _active := true

#func _init(ctx: Context) -> void:
#	pass

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
	_rect = Rect2(-size * 0.5, size * 0.5)

func size() -> Vector2:
	return _rect.size

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
	_visible = _visible

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

func relative_transform(
	compponent: Component,
	type: int,
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = _rect.size
) -> void:
	match type:
		TopHSplit:
			var t = Transform2D.IDENTITY
			t.origin = Vector2(100, 100)
			var pos := _position
			var size := _rect.size
			size.y *= 0.5
			pos += offset
			size -= offset * 2
			compponent.set_transform(pos, size, _rotation)
		BottomHSplit:
			var pos := _position
			var size := _rect.size
			size.y *= 0.5
			pos.y += size.y
			pos += offset
			size -= offset * 2
			compponent.set_transform(pos, size, _rotation)
		LeftVSplit:
			var pos := _position
			var size := _rect.size
			size.x *= 0.5
			pos += offset
			size -= offset * 2
			compponent.set_transform(pos, size, _rotation)
		RightVSplit:
			var pos := _position
			var size := _rect.size
			size.x *= 0.5
			pos.x += size.x
			pos += offset
			size -= offset * 2
			compponent.set_transform(pos, size, _rotation)
		Center:
			var pos := _position
			var size := _rect.size
			pos.x += (size.x - custom_size.x) * 0.5
			pos.y += (size.y - custom_size.y) * 0.5
			pos += offset
			custom_size -= offset * 2
			compponent.set_transform(pos, custom_size, _rotation)
		CenterLeft:
			var pos := _position
			var size := _rect.size
			pos.x += offset.x
			pos.y += (size.y - custom_size.y) * 0.5
			compponent.set_transform(pos, custom_size, _rotation)
		CenterRight:
			var pos := _position
			var size := _rect.size
			pos.x += size.x - custom_size.x - offset.x
			pos.y += (size.y - custom_size.y) * 0.5
			compponent.set_transform(pos, custom_size, _rotation)
		CenterTop:
			var pos := _position
			var size := _rect.size
			pos.x += (size.x - custom_size.x) * 0.5
			pos.y += offset.y
			compponent.set_transform(pos, custom_size, _rotation)
		CenterBottom:
			var pos := _position
			var size := _rect.size
			pos.y += size.y - custom_size.y - offset.x
			pos.x += (size.x - custom_size.x) * 0.5
			compponent.set_transform(pos, custom_size, _rotation)
		TopLeft:
			var pos := _position
			var size := _rect.size
			pos += offset
			compponent.set_transform(pos, custom_size, _rotation)
		BottomLeft:
			var pos := _position
			var size := _rect.size
			pos.x += offset.x
			pos.y += size.y - custom_size.y - offset.y
			compponent.set_transform(pos, custom_size, _rotation)
		TopRight:
			var pos := _position
			var size := _rect.size
			pos.x += size.x - custom_size.x - offset.x
			pos.y += offset.y
			compponent.set_transform(pos, custom_size, _rotation)
		BottomRight:
			var pos := _position
			var size := _rect.size
			pos.x += size.x - custom_size.x - offset.x
			pos.y += size.y - custom_size.y - offset.y
			compponent.set_transform(pos, custom_size, _rotation)
		Padding:
			var pos := _position
			var size := _rect.size
			pos += offset
			size -= offset * 2
			compponent.set_transform(pos, size, _rotation)
		MarginLeft:
			var pos := _position
			var size := _rect.size
			pos.x -= (size.x + offset.x)
			compponent.set_transform(pos, custom_size, _rotation)
		MarginRight:
			var pos := _position
			var size := _rect.size
			pos.x += (size.x + offset.x)
			compponent.set_transform(pos, custom_size, _rotation)
		MarginTop:
			var pos := _position
			var size := _rect.size
			pos.y -= (size.y + offset.y)
			compponent.set_transform(pos, custom_size, _rotation)
		MarginBottom:
			var pos := _position
			var size := _rect.size
			pos.y += (size.y + offset.y)
			compponent.set_transform(pos, custom_size, _rotation)
