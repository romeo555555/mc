extends Object
class_name Select

#var _clicked := false setget set_clicked, clicked
#var _hovered := false
var _drag := false
var _dragging := false
var _drop := false
var _mouse_pos: Vector2
var _this_player_id: String
var _player_id: String
var _prev_card_id: int
var _card_id: int
#var _card: Card

#state
var _players: Dictionary = {}

var _select_line_id: int
var _select_rect: Rect2
var select_card:=false
var _cached_rect:= Rect2(0,0,0,0)

func set_state(players: Dictionary):
	_players = players

func state() -> Dictionary:
	return _players

func reset():
#	_clicked = false
#	_hovered = false
	_drag = false
#	_dragging = false
	_drop = false

#func set_card(card: Card):
#	_card = card
#
#func card() -> Card:
#	return _card

func get_player(player_id: String) -> Player:
	return _players[player_id]

func player() -> Player:
	return _players[_player_id]

func set_card_id(card_id: int):
	_prev_card_id = _card_id
	_card_id = card_id

func card_id() -> int:
	return _card_id

func prev_card_id() -> int:
	return _card_id

func set_this_player_id(player_id: String):
	_this_player_id = player_id

func this_player_id() -> String:
	return _this_player_id

func set_player_id(player_id: String):
	_player_id = player_id

func player_id() -> String:
	return _player_id

func set_mouse_pos(pos: Vector2):
	_mouse_pos = pos

func mouse_pos() -> Vector2:
	return _mouse_pos

#func set_clicked(clicked: bool):
#	_clicked = clicked
#
#func clicked() -> bool:
#	return _clicked
#
#func set_hovered(hovered: bool):
#	_hovered = hovered
#
#func hovered() -> bool:
#	return _hovered

func set_drag(drag: bool):
	_drag = drag

func drag() -> bool:
	return _drag

func set_dragging(dragging: bool):
	_dragging = dragging

func dragging() -> bool:
	return _dragging

func set_drop(drop: bool):
	_drop = drop

func drop() -> bool:
	return _drop
