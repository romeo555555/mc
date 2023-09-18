#tool
extends Control

var screen_size := Vector2(1980, 1080)
var board: View = View.new()
var setting: View = View.new()
var end: View = View.new()
var select: Select = Select.new()

var _texture: Texture
var _rect: Rect2
#var _data

func _ready():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
	Physics2DServer.set_active(false)
	PhysicsServer.set_active(false)
	
	board.setup(Rect2(Vector2.ZERO, screen_size), load("res://assets/board1.png"))
	setting.setup(Rect2(30,30, 100, 100))
	end.setup(Rect2(screen_size.x - 500, screen_size.y * 0.5, 300, 300))
	var state: Dictionary = {}
	setup_player(state, "Client", true)
	setup_player(state, "Opp")
	select.set_state(state)

func setup_player(state: Dictionary, player_id: String, is_this_player: bool = false):
#	var id := player_id.hash()
	var width: float = 1980
	var height: float = 1080
	var half_height: float = height * 0.5
	var player := Player.new()
	if is_this_player:
		select.set_this_player_id(player_id)
		player.setup(Rect2(0.0, half_height, width, half_height), null, Vector2(20, 20), true)
	else:
		player.setup(Rect2(0.0, 0.0, width, half_height), null, Vector2(20, 20))
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		player.tabel.cast_left(card)
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		player.tabel.cast_right(card)
	for i in range(7): 
		var card: Card = Card.new()
		card.setup()
		player.hand.add_card(card)

	state[player_id] = player
	print("Add player", player_id)

	
	var curve = $Path2D.curve
	for i in range(curve.get_point_count()):
		print(
			"point: ", curve.get_point_position(i),
			"\n in: ", curve.get_point_in(i),
			"\n out: ", curve.get_point_out(i)
		)

func _input(event: InputEvent):
	var clicked: bool = event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT and event.pressed
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		select.set_mouse_pos(mouse_pos)
	var mouse_pos: Vector2 = select.mouse_pos()
	if setting.has_point(mouse_pos):
		handler_setting(clicked)
	elif end.has_point(mouse_pos):
		handler_end(clicked)
	else:
		for player_id in select.state():
			select.set_player_id(player_id)
			var player: Player = select.get_player(player_id)
			if player.has_point(mouse_pos):
				if player.factorys.has_point(mouse_pos):
					handler_factorys(clicked)
				elif player.secrets.has_point(mouse_pos):
					handler_secrets(clicked)
				elif player.graveyard.has_point(mouse_pos):
					handler_graveyard(clicked)
				elif player.deck.has_point(mouse_pos):
					handler_deck(clicked)
				elif player.tabel.avatar.has_point(mouse_pos):
					handler_avatar(clicked)
				elif player.hand.has_point(mouse_pos):
					var card_id := player.hand.has_point_on_card(mouse_pos)
					if card_id > -1:
						handler_hand_card(clicked, card_id)
					else:
						handler_hand(clicked)
				elif player.tabel.has_point(mouse_pos):
					var card_id := player.tabel.has_point_on_card(mouse_pos)
					if card_id > -1:
						handler_tabel_card(clicked, card_id)
					else:
						handler_tabel(clicked)
				else:
					handler_none()
	select.reset()

func _process(delta):
#	var arrow := $Board/Arrow
#	arrow.clear_points()
#	var curve = Curve2D.new()
#	curve.add_point(get_rect().size/2,
#			Vector2(0,0),
#			(get_rect().size/2).direction_to(get_viewport().size/2) * 75)
#	curve.add_point(mouse_pos,
#			Vector2(0, 0), Vector2(0, 0))
#	arrow.set_points(curve.get_baked_points())
	update()

func _draw():
	board.draw(self)
#	setting.draw(self)
#	end.draw(self)
	for player_id in select.state():
		var player: Player = select.get_player(player_id)
		player.draw(self)
#	if select_card:
#		draw_rect(_cached_rect, Color.aquamarine, false, 10)
#	if card:
#		card.set_position(mouse_pos)
#		card.draw(self, Vector2(200, 200))

func get_drag_data(position: Vector2):
	select.set_drag(true)
	return { id = "foobar" }

func can_drop_data(position: Vector2, data) -> bool:
	return select.dragging()

func drop_data(position: Vector2, data) -> void:
	select.set_dragging(false)
	select.set_drop(true)

func handler_avatar(clicked: bool):
	print("avatar")

func handler_hand(clicked: bool):
	print("hand")

func handler_tabel(clicked: bool):
	print("tabel")

func handler_tabel_card(clicked: bool, card_id: int):
#	if select.drag():
#		return
#	elif select.dragging():
#		return
#	elif select.drop():
#		return
#	elif clicked:
#		return
#	else:
	print("tabel_id: ", card_id)
#	select_card = true
#	_cached_rect = Rect2(players[select_player].tabel._cards[card_id].position(), Vector2(200, 200))
#	if _drag:
#		var _card = players[select_player].tabel.remove(card_id)
#		print(_card)
#		card = _card
#		_drag = false
#	select.set_hovered(true)

func handler_hand_card(clicked: bool, card_id: int):
	print("hand_id: ",card_id)
	select.player().hand.hover_on(card_id)

func handler_factorys(clicked: bool):
	print("fact")

func handler_graveyard(clicked: bool):
	print("grave")

func handler_secrets(clicked: bool):
	print("secret")

func handler_deck(clicked: bool):
	if clicked:
		select.player().deck.set_hightlight_color(Color.red)
	else:
		select.player().deck.set_hightlight_color(Color.yellow)
	print("deck")

func handler_setting(clicked: bool):
	print("setting")

func handler_end(clicked: bool):
	print("end")

func handler_none():
	print("none")
