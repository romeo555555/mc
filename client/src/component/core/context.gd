extends Object
class_name Context

var screen_size := Vector2(1980, 1080)
var hover_line_size := 15
var hover_color := Color.aliceblue
var clicked_color := Color.red
var font_size: int = 42
var font = DynamicFont.new()
#var font = get_font("font")

var arrow: Line2D
var tween: Tween
var canvas: CanvasItem
var delta: float = 0
var _mouse_pos: Vector2
var _clicked := false setget , clicked


var _player_id: String
var _this_player_id: String
var _targeting := false
var _dragging := false


enum { None, Enter, Exit, Click, ClickOutside }
#enum { None, Hand, L_Tabel, R_Tabel, Deck, Factorys, Graveyard, Secrets, Setting, End}
var _selected := false
#var _drag_player_id: String
#var _drag_view_id: int = 0
#var _drag_card_id: int = -1
#
#var _prev_player_id: String
#var _prev_view_id: int = 0
#var _prev_card_id: int = -1
#var _view_id: int = 0
#var _card_id: int = -1


#var _target: []
#var _card: Card = null
#var _card_pivote = Vector2.ZERO

func _init(node_arrow: Line2D, node_tween: Tween):
	font.font_data = load("res://assets/font/SansSerif.ttf")
	font.set_size(font_size)
	arrow = node_arrow
	tween = node_tween
#	tween.interpolate_method(card, "set_position", Vector2.ZERO, Vector2(500, 500), 3, 1)
#	tween.start()
#	if ctx.clicked():
#		ctx.tween.interpolate_method(card, "set_position", card.position(), ctx.mouse_pos(), 3, 1)
##		ctx.tween.start()
#	ctx.tween.interpolate_method(card1, "set_position", card1.position(), ctx.mouse_pos(), 3, 1)
#	ctx.tween.start()
	
func set_canvas(cs: CanvasItem) -> void:
	canvas = cs

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

func set_clicked(clicked: bool) -> void:
	_clicked = clicked

func clicked() -> bool:
	return _clicked

func set_player_id(player_id: String) -> void:
#	_prev_player_id = _player_id
	_player_id = player_id

func player_id() -> String:
	return _player_id

func text_position(text: String) -> Vector2:
#	var h_font_size = ctx.font_size * 0.5
#	ctx.canvas.draw_string(ctx.font, center() - ctx.font.get_string_size(text) * 0.5 + Vector2(0, h_font_size), text)
	var pos_text: Vector2 = font.get_string_size(text) * 0.5
	pos_text.x *= -1
	pos_text.y -= font_size  * 0.25
	return pos_text

func draw_shadowing() -> void:
	canvas.draw_rect(Rect2(Vector2.ZERO, screen_size), Color(0,0,0, 0.5))
#func send_action(action: int) -> void:
#	actions.push_front(action)
#	actions.set(actions_count, action)
#	actions_count += 1

func selecting() -> void:
	_selected = true

func selected() -> bool:
	return _selected

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

#func set_card_id(card_id: int) -> void:
#	_prev_card_id = _card_id
#	_card_id = card_id
#
#func card_id() -> int:
#	return _card_id


