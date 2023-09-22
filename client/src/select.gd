extends Object
class_name Select

enum { None, Hand, Tabel, Avatar, Deck, Factorys, Graveyard, Secrets, Setting, End}
var _clicked := false setget , clicked
#var _hovered := false
var _drag := false
var _targeting := false
var _casting := false
var _drop := false
var _mouse_pos: Vector2
var _this_player_id: String
var _target_player_id: String
var _target_type_id: int
var _target_card_id: int
var _player_id: String
var _type_id: int
var _card_id: int
var _card: Card = null
var _card_pivote = Vector2.ZERO

var _state: Dictionary = {}
var board: View = View.new()
var setting: View = View.new()
var end: View = View.new()
var arrow: Line2D = null

func set_state(state: Dictionary):
	_state = state

func state() -> Dictionary:
	return _state

func set_sense(type_id: int, player_id: String = "", card_id: int = -1, can_drag: bool = false):
#	if _hovered:
	var view: View = view(_player_id, _type_id)
	if view:
		view.mouse_exit()
#			_hovered = false
#			view.set_highlight(false)
	
	if _drop:
		_card = null
		_casting = false
		_targeting = false
	
	if can_drag and player_id == _this_player_id and card_id > -1:
		if type_id == Hand:
			_casting = true
			_card = this_player().hand.remove_card(card_id)
			_card.set_position(mouse_pos())
			_card.set_rotation(0)
			_card.set_scale(Vector2.ONE)
				
		if type_id == Tabel:
			_targeting = true
	
	if dragging():
		_target_player_id = _player_id
		_target_type_id = _type_id
		_target_card_id = _card_id
	else:
		_player_id = player_id
		_type_id = type_id
		_card_id = card_id
	
	view(_player_id, _type_id).mouse_enter(_clicked)
	
	_clicked = false
	_drag = false
	_drop = false

func draw(ctx: CanvasItem, font):
	if _card:
		_card.set_position(mouse_pos() - _card_pivote)
		this_player().hand.draw_card(ctx, _card, font)
#		ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func aim():
	arrow.clear_points()
	var curve = Curve2D.new()
	curve.add_point(board._rect.size/2,
			Vector2(0,0),
#			TODO:
#			(board._rect.size/2).direction_to(get_viewport().size/2) * 75)
			(board._rect.size/2).direction_to(board._rect.size/2) * 75)
	curve.add_point(mouse_pos(),
			Vector2(0, 0), Vector2(0, 0))
	arrow.set_points(curve.get_baked_points())

func view(player_id: String, type_id: int) -> View:
	var player: Player = player(player_id)
	if player:
		match type_id:
			Hand:
				return player.hand
			Tabel:
				return player.tabel
			Avatar: 
				return player.tabel.avatar
			Deck: 
				return player.deck
			Factorys: 
				return player.factorys
			Graveyard: 
				return player.graveyard
			Secrets:
				return player.secrets
			_:
				return null
	else: 
		match _type_id:
			Setting:
				return setting
			End:
				return end
			_:
				return null

func card(card_id: int = _card_id):
	var player: Player = player(_player_id)
	if player:
		match _type_id:
			Hand:
				_card_pivote = player.hand._card_pivot
				return player.hand.get_card(card_id)
			Tabel:
				_card_pivote = player.hand._card_pivot
				return player.tabel.get_card(card_id)

func card_id() -> int:
	return _card_id

func type_id() -> int:
	return _type_id
	
func set_this_player_id(player_id: String):
	_this_player_id = player_id

func this_player_id() -> String:
	return _this_player_id

func this_player() -> Player:
	return _state[_this_player_id]

func player_id() -> String:
	return _player_id

func player(player_id: String) -> Player:
	return _state.get(player_id)

func set_input(pos: Vector2, clicked: bool):
	_mouse_pos = pos
	_clicked = clicked

func mouse_pos() -> Vector2:
	return _mouse_pos

func clicked() -> bool:
	return _clicked

func start_drag():
	_drag = true

func drag() -> bool:
	return _drag

func casting() -> bool:
	return _casting

func targeting() -> bool:
	return _targeting

func dragging() -> bool:
	return _targeting or _casting

func start_drop():
	_drop = true

func drop() -> bool:
	return _drop

func set_arrow(ar: Line2D):
	arrow = ar

func input(mouse_pos: Vector2, clicked: bool):
#	print("CLICKED: ", clicked, mouse_pos)
	set_input(mouse_pos, clicked)
	if setting.has_point(mouse_pos):
		set_sense(Setting)
	elif end.has_point(mouse_pos):
		set_sense(End)
	else:
		for player_id in state():
			var player: Player = player(player_id)
			#TODO: detect up or down and active or no
			if player.has_point(mouse_pos):
				if player.factorys.has_point(mouse_pos):
					set_sense(Factorys, player_id)
				elif player.secrets.has_point(mouse_pos):
					set_sense(Secrets, player_id)
				elif player.graveyard.has_point(mouse_pos):
					set_sense(Graveyard, player_id)
				elif player.deck.has_point(mouse_pos):
					set_sense(Deck, player_id)
				elif player.tabel.avatar.has_point(mouse_pos):
					set_sense(Avatar, player_id)
				elif player.hand.has_point(mouse_pos):
					var card_id := player.hand.has_point_on_card(mouse_pos)
#					if clicked:
					if drop():
						if casting() and player_id == this_player_id():
							var card: Card = player.hand.remove_card(_card_id)
							player.hand.add_card(card, card_id)
					set_sense(Hand, player_id, card_id, drag())
				elif player.tabel.has_point(mouse_pos):
					var tabel: Tabel = player.tabel
					var is_right := tabel.has_right_side(mouse_pos)
					var card_id := tabel.has_point_on_card(mouse_pos, is_right)
#					if clicked:
					print("tabel carf: ", card_id)
#					if targgeting() and player_id != this_player_id():
					if casting() and player_id == this_player_id() and card_id > -1:
						tabel.casting_on(card_id, is_right)
					if drop():
#						if targgeting() and player_id != this_player_id():
#							attack
						if casting():
							var card: Card = _card
							if !tabel.is_full(is_right):
								tabel.add_card(card, is_right, card_id)
							elif !tabel.is_full(!is_right):
								tabel.add_card(card, is_right)
							else:
								this_player().hand.add_card(card, _card_id)
					set_sense(Tabel, player_id, card_id, drag())
#				else:
#					handler_none()
