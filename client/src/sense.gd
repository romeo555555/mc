extends Object
class_name Sense

enum { None, Enter, Exit, Click, ClickOutside }
#enum { None, Hand, L_Tabel, R_Tabel, Deck, Factorys, Graveyard, Secrets, Setting, End}

var _mouse_pos: Vector2
var _clicked := false setget , clicked
var _selected := false

var _targeting := false
var _dragging := false
#var _drag_player_id: String
#var _drag_view_id: int = 0
#var _drag_card_id: int = -1
#
#var _prev_player_id: String
#var _prev_view_id: int = 0
#var _prev_card_id: int = -1

#var actions_count: int = 0
var actions: Array = []
var _this_player_id: String
var _player_id: String
#var _view_id: int = 0
#var _card_id: int = -1


#var _target: []
#var _card: Card = null
#var _card_pivote = Vector2.ZERO

func send_action(action: int) -> void:
	actions.push_front(action)
#	actions.set(actions_count, action)
#	actions_count += 1

func selecting() -> void:
	_selected = true

func selected() -> bool:
	return _selected

#func set_card_id(card_id: int) -> void:
#	_prev_card_id = _card_id
#	_card_id = card_id
#
#func card_id() -> int:
#	return _card_id

func set_player_id(player_id: String) -> void:
#	_prev_player_id = _player_id
	_player_id = player_id

func player_id() -> String:
	return _player_id

#func set_input(pos: Vector2, clicked: bool) -> void:
#	_mouse_pos = pos
#	_clicked = clicked
#	_selected = false

func set_input(event: InputEvent) -> void:
	_mouse_pos = \
		event.position \
		if event is InputEventMouseMotion \
		else _mouse_pos
	_clicked = \
		event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed
	_selected = false

func mouse_pos() -> Vector2:
	return _mouse_pos

func clicked() -> bool:
	return _clicked

#func set_last_entered_mouse_pos(pos: Vector2) -> void:
#	_last_entered_mouse_pos = pos
#
#func last_entered_mouse_pos() -> Vector2:
#	return _last_entered_mouse_pos

func start_targeting() -> void:
	_targeting = true

func targeting() -> bool:
	return _targeting

func stop_targeting() -> void:
	_targeting = false

func start_drag() -> void:
	_dragging = true

func dragging() -> bool:
	return _dragging

func stop_drag() -> void:
	_dragging = false

#func drag_card_id() -> int:
#	return _drag_card_id
#
#func drag_view_id() -> int:
#	return _drag_view_id
#
#func drag_player_id() -> String:
#	return _drag_player_id

#func card(card_id: int = _card_id) -> void:
#	var player: Player = player(_player_id)
#	if player:
#		match _type_id:
#			Hand:
#				_card_pivote = player.hand._card_pivot
#				return player.hand.get_card(card_id)
#			Tabel:
#				_card_pivote = player.hand._card_pivot
#				return player.tabel.get_card(card_id)


