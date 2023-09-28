extends Object
class_name Sense

enum { None, Hand, L_Tabel, R_Tabel, Deck, Factorys, Graveyard, Secrets, Setting, End}
enum { Cast, Attack, ShiftinHand }
#TODO:scene state
enum Screen { Main, Setting, Deck, Factorys, Graveyard, Secrets, Card, Attack }

var _mouse_pos: Vector2
var _clicked := false setget , clicked

var _targeting := false
var _dragging := false
var _drag_player_id: String
var _drag_view_id: int = 0
var _drag_card_id: int = -1

var _prev_player_id: String
var _prev_view_id: int = 0
var _prev_card_id: int = -1

var _events: Array = []
var _this_player_id: String
var _player_id: String
var _view_id: int = 0
var _card_id: int = -1

#var _target: []
#var _card: Card = null
#var _card_pivote = Vector2.ZERO

#func input_event(event_id: int, view_id: int = 0, player_id: String = "", card_id: int = -1):
#	if _player_id != player_id and _view_id != view_id:
#		_prev_need_update = true
#		_player_id = _player_id
#		_prev_need_update_view_id = _view_id
#	_events.push_back(event_id)
#	_player_id = player_id
#	_view_id = view_id
#	_card_id = card_id

func event() -> Array:
	return _events

func set_prev_view_id_none():
	_prev_view_id = 0

func prev_view_id() -> int:
	return _prev_view_id
	
func prev_player_id() -> String:
	return _prev_player_id

func set_card_id(card_id: int):
	_prev_card_id = _card_id
	_card_id = card_id

func card_id() -> int:
	return _card_id

func set_view_id(view_id: int):
	_prev_view_id = _view_id
	_view_id = view_id

func view_id() -> int:
	return _view_id

func set_player_id(player_id: String):
	_prev_player_id = _player_id
	_player_id = player_id

func player_id() -> String:
	return _player_id

func set_this_player_id(player_id: String):
	_this_player_id = player_id

func this_player_id() -> String:
	return _this_player_id

func set_input(pos: Vector2, clicked: bool):
	_mouse_pos = pos
	_clicked = clicked

func mouse_pos() -> Vector2:
	return _mouse_pos

func clicked() -> bool:
	return _clicked

func start_targeting():
	_targeting = true
	start_drag()

func targeting() -> bool:
	return _targeting

func stop_targeting():
	_targeting = false
	stop_drag()

func start_drag():
	_dragging = true
	_drag_player_id = _player_id
	_drag_view_id = _view_id
	_drag_card_id = _card_id

func dragging() -> bool:
	return _dragging

func stop_drag():
	_dragging = false

func drag_card_id() -> int:
	return _drag_card_id

func drag_view_id() -> int:
	return _drag_view_id

func drag_player_id() -> String:
	return _drag_player_id

#func card(card_id: int = _card_id):
#	var player: Player = player(_player_id)
#	if player:
#		match _type_id:
#			Hand:
#				_card_pivote = player.hand._card_pivot
#				return player.hand.get_card(card_id)
#			Tabel:
#				_card_pivote = player.hand._card_pivot
#				return player.tabel.get_card(card_id)


