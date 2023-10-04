extends Object
class_name Sense


#enum { None, Hand, L_Tabel, R_Tabel, Deck, Factorys, Graveyard, Secrets, Setting, End}
enum { 
	None,
	ScreenMain, 
	ScreenSetting, 
	ScreenDeck, 
	ScreenFactorys, 
	ScreenGraveyard, 
	ScreenSecrets, 
	ScreenCard, 
	ScreenTabelCard, 
	ScreenAttack,
	MouseExit,
	MouseMove,
	Cast, 
	Attack, 
	ShiftinHand,
	EndTurn
}

var _last_entered_mouse_pos: Vector2 = Vector2(-100, -100)
var _mouse_pos: Vector2
var _clicked := false setget , clicked
var _select := false

var _targeting := false
var _dragging := false
var _drag_player_id: String
var _drag_view_id: int = 0
var _drag_card_id: int = -1

var _prev_player_id: String
var _prev_view_id: int = 0
var _prev_card_id: int = -1

#var actions_count: int = 0
#var actions : PoolIntArray = PoolIntArray([0,0,0,0,0,0,0,0,0,0])
var actions: Array = []
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

func send_action(action: int):
	actions.push_front(action)
#	actions.set(actions_count, action)
#	actions_count += 1

func selecting():
	_select = true

func select() -> bool:
	return _select

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
	_select = false
	_mouse_pos = pos
	_clicked = clicked

func set_last_entered_mouse_pos(pos: Vector2):
	_last_entered_mouse_pos = pos

func last_entered_mouse_pos() -> Vector2:
	return _last_entered_mouse_pos

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


