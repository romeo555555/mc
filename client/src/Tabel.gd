extends Control


export(int) var _max_size_side := 4
export(bool) var _can_drag := false
export(bool) var _can_drop := false
export(bool) var _miroring := false
var _card_size := Vector2(200, 200)
var _card_indent := Vector2(10, 0)
var _left_count := 0
var _right_count := 0
var _avatar_id := 0
onready var _avatar_rect: Rect2 = $Avatar.get_rect()
#var 
var _clicked := false
var _hovered := false
var _dragging := false
var _cached_card_id: int
var _cached_prev_card_id: int
var _cached_rect: Rect2

func _ready():
	self.connect("mouse_exited", self, "_mouse_exited")

func _mouse_exited():
	hovered_off()
#	if _dragging:
	aligment()
signal click_on_card()
func _gui_input(event: InputEvent):
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT and event.pressed:
		_clicked = true
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		check_hovered(mouse_pos)
		if _avatar_rect.has_point(mouse_pos):
			set_select_card(_avatar_id, _avatar_rect)
			#else:
			set_hovered()
		elif containe(mouse_pos, mouse_pos.x > _avatar_rect.position.x):
			if _clicked:
				print("go")
				get_parent().get_parent()._on_Card_pressed()
#				emit_signal("click_on_card")
				_clicked = false
			#if _clicked:
			#else:
			set_hovered()
			pass

#func _process(delta):
##	Input.
#	pass

func containe(mouse_pos: Vector2, is_right_side: bool) -> bool:
	if is_right_side:
		for i in range(_left_count + 1, card_count() + 1):
			var rect: Rect2 = get_child(i).get_rect()
			if rect.has_point(mouse_pos):
				set_select_card(i, rect)
				return true
	else: 
		for i in range(1, _left_count + 1):
			var rect: Rect2 = get_child(i).get_rect()
			if rect.has_point(mouse_pos):
				set_select_card(i, rect)
				return true
	return false

func set_select_card(idx: int, rect: Rect2):
	_cached_prev_card_id = _cached_card_id
	_cached_card_id = idx
	_cached_rect = rect

func select_card() -> Node:
	return get_child(_cached_card_id)
	
func set_hovered():
	if _hovered:
		get_child(_cached_prev_card_id).get_child(0).set_visible(false)
	select_card().get_child(0).set_visible(true)
	_hovered = true

func check_hovered(mouse_pos: Vector2):
	if _hovered and not _cached_rect.has_point(mouse_pos):
		hovered_off()

func hovered_off():
	select_card().get_child(0).set_visible(false)
	_hovered = false

func card_count() -> int:
	return get_child_count() - 1

func can_cast_right() -> bool:
	return !_right_count == _max_size_side

func can_cast_left() -> bool:
	return !_left_count == _max_size_side

func cast_right(card: Control):
	var x := (rect_size.x + _card_size.x) * 0.5 + _card_indent.x \
		+ (_card_size.x + _card_indent.x) * _right_count
	add_child(card)
	card.set_position(Vector2(x, 0))
	_right_count += 1

func cast_left(card: Control):
	var x := (rect_size.x - _card_size.x) * 0.5 - _card_indent.x \
	 - _card_size.x - (_card_size.x + _card_indent.x) * _left_count
	add_child(card)
	move_child(card, 1)
	card.set_position(Vector2(x, 0))
	_left_count += 1

#func add_cards(cards:Array):
#	for card in cards:
#		add_child(card)
#	aligment()

func remove_card_right(idx: int):
	if idx == _avatar_id:
		return
	remove_child(get_child(idx))

func aligment_left():
	aligment()
	var offset := _card_size + _card_indent
	offset.y = 0
	var fchild := select_card()
	var pos: Vector2 = fchild.get_rect().position - offset 
	pos.x += _card_size.x
	fchild.set_position(pos)
	for i in range(_cached_card_id, _left_count + 1):
		pos -= offset
		get_child(i).set_position(pos)

func aligment_right():
	aligment()
	var offset := _card_size + _card_indent
	offset.y = 0
	var fchild := select_card()
	var pos: Vector2 = fchild.get_rect().position + offset
	fchild.set_position(pos)
	for i in range(_cached_card_id + 1, card_count() + 1):
		pos += offset
		get_child(i).set_position(pos)

func aligment():
	var offset := _card_size.x + _card_indent.x
	var x := (rect_size.x + _card_size.x) * 0.5 + _card_indent.x
	for i in range(_left_count + 1, card_count() + 1):
		get_child(i).set_position(Vector2(x, 0))
		x += offset
	var x2 := (rect_size.x - _card_size.x) * 0.5 - _card_indent.x - _card_size.x 
	for i in range(1, _left_count + 1):
		get_child(i).set_position(Vector2(x2, 0))
		x2 -= offset
#func aligment():
#	var count := get_child_count()
#	var offset := _card_size.x + _card_indent.x
#	var start_x := offset * 0.5
#	if aligment == 1:
#		offset *= -1
#		print(rect_position)
#		print(rect_size)
#		start_x = start_x + rect_size.x + offset * 2 - _card_indent.x
##		start_x = start_x + rect_size.x + offset * 2 + _card_indent.x
##	var x := start_x
#	var x := start_x + _card_indent.x
#	for i in range(count):
##		fit_child_in_rect(get_child(i), Rect2(Vector2(x, 0), _card_size))
#		get_child(i).set_position(Vector2(x, 0))
#		x += offset

#func aligment():
#	var count := card_count()
#	var offset := _card_size.x + _card_indent.x
#
#	var start_x := (count * offset - _card_indent.x) * -1
#	var x := (rect_size.x + start_x) * 0.5
#	for i in range(1, count + 1):
#		get_child(i).set_position(Vector2(x, 0))
#		x += offset

#	var start_x := (count * offset - _card_indent.x) * -1
#	var x := (rect_size.x + start_x) * 0.5
#	for i in range(skip_count, count + skip_count):
#		get_child(i).set_position(Vector2(x, 0))
#func _process(delta):
#	if _dragging:
#		var arrow := $Avatar/Arrow
#		arrow.clear_points()
#		var curve = Curve2D.new()
#		curve.add_point(get_rect().size/2,
#				Vector2(0,0),
#				(get_rect().size/2).direction_to(get_viewport().size/2) * 75)
#		curve.add_point(get_global_mouse_position(),
#				Vector2(0, 0), Vector2(0, 0))
#		arrow.set_points(curve.get_baked_points())
#	var preview = $Avatar/Arrow/Head.duplicate()
#	set_drag_preview(preview)
func get_drag_data(mouse_pos: Vector2):
#	if _avatar_rect.has_point(mouse_pos):
#		pass
#	else:
#		var preview = select_card().duplicate()
#		set_drag_preview(preview)
#		return { id = "foobar" }
######
#	var arrow := $Avatar/Arrow
#	arrow.clear_points()
#	var curve = Curve2D.new()
#	curve.add_point(get_rect().size/2,
#			Vector2(0,0),
#			(get_rect().size/2).direction_to(get_viewport().size/2) * 75)
#	curve.add_point(mouse_pos,
#			Vector2(0, 0), Vector2(0, 0))
#	arrow.set_points(curve.get_baked_points())
	var preview = $Avatar/Arrow/Head.duplicate()
	set_drag_preview(preview)
	get_parent().get_parent()._dragging = true
#	_dragging = true
	return { id = "foobar" }

#		#if click
#	elif containe(mouse_pos, mouse_pos.x > _avatar_rect.position.x):
#		var preview = .duplicate()
#		set_drag_preview(preview)
#		return { id = "foobar" }
#	if is_card_select():
#		if guit == GUIT.HAND:
#			set_dragging()
#			var preview = gui_client.l_tabel_cards[select_card_id].duplicate()
#			set_drag_preview(preview)
#			return { id = "foobar" } #, card = select_node
#		if guit == GUIT.L_TABEL || guit == GUIT.R_TABEL:
#			set_dragging()
#			$ArrowLine.show()
#			$ArrowLine.set_point_position(0, position)
#			$ArrowLine.set_point_position(1, position)
#			var preview = $Arrow
#			preview.set_visible(true)
#			set_drag_preview(preview.duplicate())
#			preview.set_visible(false)
#			return { id = "foobar", card = select_node }
#
#func _notification(what: int):
#	if what == NOTIFICATION_MOUSE_ENTER:
#		print("enter")

func can_drop_data(mouse_pos: Vector2, data) -> bool:
	if _can_drop:
		var is_right := mouse_pos.x > _avatar_rect.position.x
		if containe(mouse_pos, is_right):
			if is_right:
				if _right_count == _max_size_side:
					return false
				aligment_right()
			else:
				if _left_count == _max_size_side:
					return false
				aligment_left()
#				aligment(mouse_pos, true)
		return true
	return false
#
func drop_data(position: Vector2, data) -> void:
	get_parent().get_parent()._dragging=false
#	_dragging=false
	pass
##	if is_hovered():
##		if guit == GUIT.HAND:
##		if guit == GUIT.TABEL:
#	clear_action()
#	$ArrowLine.hide()
#	var card = gui_client.l_tabel_cards[select_card_id].duplicate()
#	var tween = get_node("Tween")
#	tween.interpolate_method(card, "set_position",
#			Vector2(0, 0), position, 1,
#			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
#

#func aligment_left(from: int = 0, to: int = get_child_count(), blink: bool = false):
#	var children := get_children()
#	var offset := _card_size.x + _card_indent.x
#	var start_x := (count * offset - _card_indent.x) * -1
#	var x := (rect_size.x + start_x) * 0.5
#	for i in range(count):
#		fit_child_in_rect(children[i], Rect2(Vector2(x, 0), _card_size))
##		children[i].set_position(Vector2(x, _rect.position.y))
#		x += offset


