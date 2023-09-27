extends Control

var screen_size := Vector2(1980, 1080)
var sense: Sense = Sense.new()
var font = DynamicFont.new()
#var font = get_font("font")
var players: Dictionary = {}
var board: View = View.new()
var setting: View = View.new()
var end: View = View.new()

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

	font.font_data = load("res://assets/font/SansSerif.ttf")
	font.size = 42
	sense.set_arrow($Arrow)
	board.setup(Sense.None, Rect2(Vector2.ZERO, screen_size), load("res://assets/board1.png"))
	setting.setup(Sense.Setting, Rect2(30,30, 100, 100))
	end.setup(Sense.End, Rect2(screen_size.x - 500, screen_size.y * 0.5, 300, 300))
	var state: Dictionary = {}
	setup_player(state, "Opp")
	setup_player(state, "Client", true)
	
	var curve = $Path2D.curve
	for i in range(curve.get_point_count()):
		print(
			"point: ", curve.get_point_position(i),
			"\n in: ", curve.get_point_in(i),
			"\n out: ", curve.get_point_out(i)
		)

func setup_player(state: Dictionary, player_id: String, is_this_player: bool = false):
#	var id := player_id.hash()
	var width: float = 1980
	var height: float = 1080
	var half_height: float = height * 0.5
	var player := Player.new()
	if is_this_player:
		sense.set_this_player_id(player_id)
		player.setup(Sense.None, Rect2(0.0, half_height, width, half_height), null, Vector2(20, 20), true)
	else:
		player.setup(Sense.None, Rect2(0.0, 0.0, width, half_height), null, Vector2(20, 20))
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		player.tabel.add_card(card, false)
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		player.tabel.add_card(card, true)
	for i in range(7): 
		var card: Card = Card.new()
		card.setup()
		player.hand.add_card(card)
	
	players[player_id] = player
	print("Add player", player_id)

func _input(event: InputEvent):
	if sense.prev_view_id() != Sense.None:
		get_view(sense.prev_player_id(), sense.prev_view_id())._mouse_exit(sense)
		sense.set_prev_view_id_none()
	var mouse_pos: Vector2 = \
		event.position \
		if event is InputEventMouseMotion \
		else sense.mouse_pos()
	var clicked: bool = \
		event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed
	sense.set_input(mouse_pos, clicked)
	input()
	print("selset:")
	print(sense.player_id())
	print(sense.view_id())
	print(sense.card_id())
	events_handler()

func input():
#	print("CLICKED: ", clicked, mouse_pos)
	if setting._mouse_enter(sense) || end._mouse_enter(sense):
		return
	for player_id in players:
		var player: Player = players.get(player_id)
		#TODO: detect up or down and active or no
		if player._mouse_enter(sense):
			sense.set_player_id(player_id)
			return

func events_handler():
	for event in sense.event():
		match event:
			#input_event
			Sense.Cast:
				pass
			Sense.Attack:
				pass
			Sense.ShiftinHand:
				pass
			#network_event
	sense.event().clear()

func get_drag_data(position: Vector2):
	if sense.player_id() == sense.this_player_id() and sense.card_id() > -1:
		if sense.view_id() == Sense.Hand:
			sense.start_drag()
			players.get(sense.this_player_id()).hand.select_card(sense.card_id())
			return { id = "drag" }
		if sense.view_id() == Sense.Tabel:
			sense.start_drag()
			#arrow
			return { id = "drag" }
	return null

func can_drop_data(position: Vector2, data) -> bool:
	return true

func drop_data(position: Vector2, data) -> void:
	if sense.drag_view_id() == Sense.Hand:
		if sense.view_id() == Sense.Hand and sense.player_id() == sense.this_player_id():
			var player: Player = players.get(sense.this_player_id())
			var card: Card = player.hand.remove_select_card()
			card.set_visible(true)
			player.hand.add_card(card, sense.card_id())
		elif sense.view_id() == Sense.Tabel and sense.player_id() == sense.this_player_id():
			var player: Player = players.get(sense.this_player_id())
			var card: Card = player.hand.remove_select_card()
			card.set_visible(true)
			player.tabel.add_card(card, sense.is_right(), sense.card_id())
		else:
			players.get(sense.this_player_id()).hand.unselect_card()
#	elif sense.drag_view_id() == Sense.Tabel:
#		if sense.view_id() == Sense.Tabel:
#		else
#
#		if targgeting() and player_id != this_player_id():
#		attack
#		if casting():
#			var card: Card = _card
#			if !tabel.is_full(is_right):
#				tabel.add_card(card, is_right, card_id)
#			elif !tabel.is_full(!is_right):
#				tabel.add_card(card, is_right)
#			else:
#				this_player().hand.add_card(card, _card_id)
	sense.start_drop()

func get_view(player_id: String, view_id: int) -> View:
	var player: Player = players.get(player_id)
	match view_id:
		Sense.Setting:
			return setting
		Sense.End:
			return end
		Sense.Hand:
			return player.hand
		Sense.Tabel:
			return player.tabel
		Sense.Deck: 
			return player.deck
		Sense.Factorys: 
			return player.factorys
		Sense.Graveyard: 
			return player.graveyard
		Sense.Secrets:
			return player.secrets
		_:
			return null

func _process(delta):
	update()
#	if sense.targeting():
#		sense.aim()

func _draw():
	board.draw(self)
#	setting.draw(self)
#	end.draw(self)
	for player_id in players:
		if player_id == sense.this_player_id():
			continue
		var player: Player = players.get(player_id)
		player.draw(self)
	var player: Player = players.get(sense.this_player_id())
	player.draw(self)
	if sense.dragging() and sense.drag_view_id() == Sense.Hand:
		player.hand.draw_select_card(self, sense.mouse_pos())
	
#	if sense.casting():
#		sense.draw(self, font)
#	if sense_card:
#		draw_rect(_cached_rect, Color.aquamarine, false, 10)
#	if card:
#		card.set_position(mouse_pos)
#		card.draw(self, Vector2(200, 200))
