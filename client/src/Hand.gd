extends Control

export(int) var _max_size := 10
export(bool) var _can_drag := false
export(bool) var _can_drop := false
export(bool) var _miroring := false
var _card_size := Vector2(200, 200)
var _card_indent := Vector2(-50, 0)
onready var _build_rect: Rect2
onready var _deck_rect: Rect2
var h_twist := 0.15
var h_height := 25.0
var _clicked := false
var _hovered := false
var _cached_card_id: int
var _cached_prev_card_id: int
var _cached_rect: Rect2

func _ready():
	if _miroring:
		var build := $Other/Build
		var deck := $Other/Deck
		var pos: Vector2 = deck.get_rect().position
		deck.set_position(build.get_rect().position)
		build.set_position(pos)
	self.connect("mouse_exited", self, "_mouse_exited")

func _mouse_exited():
	hovered_off()

func _gui_input(event: InputEvent):
	_clicked = event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT and event.pressed
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		check_hovered(mouse_pos)
		if _build_rect.has_point(mouse_pos):
#			set_select_card
			set_hovered()
		elif _deck_rect.has_point(mouse_pos):
			set_hovered()
		elif containe(mouse_pos):
			set_hovered()

func containe(mouse_pos: Vector2) -> bool:
	for i in range(1, card_count() + 1):
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

func can_add_card() -> bool:
	return !get_child_count() == _max_size

func add_card(card: Control):
	add_child(card)
	aligment()

func add_cards(cards:Array):
	for card in cards:
		add_child(card)
	aligment()

func remove_card(idx: int):
	remove_child(get_child(idx))
	aligment()

func aligment():
#	print("aligment")
	var count := card_count()
	var offset := _card_size.x + _card_indent.x
	var start_x := (count * offset - _card_indent.x) * -1
	var x := (rect_size.x + start_x) * 0.5
	var angel = -(h_twist * count / 2)
	var y = h_height * count / 2 
	for i in range(1, count + 1):
		var child = get_child(i)
		child.set_position(Vector2(x, abs(y)*1))
		child.set_rotation(angel)
		x += offset
		angel += h_twist
		y = y - h_height
#		print(child.get_position(), child.get_rotation())

func get_drag_data(position: Vector2):
	#	if _avatar_rect.has_point(mouse_pos):
#		pass
#	else:
	var preview = select_card().duplicate()
#	var preview = select_card()
#	remove_child(preview)
#	aligment()
	set_drag_preview(preview)
	return { id = "foobar", card = preview }
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
func can_drop_data(position: Vector2, data) -> bool:
	return _can_drop
#
func drop_data(position: Vector2, data) -> void:
#	print("drop")
#	add_card(data.card)
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
