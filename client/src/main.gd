extends Control

onready var scroll_container: Control = $ScrollContainer/Control
var screen_size := Vector2(1980, 1080)
var active_screen: int = 0
var font = DynamicFont.new()
const FONT_SIZE: int = 42
const CLICKED_COLOR := Color.red
const HOVER_COLOR := Color.aliceblue
const HOVER_LIZE_SIZE := 15
#var font = get_font("font")
var players: Dictionary = {}
var board: Board = Board.new()
var setting: Setting = Setting.new()
var end: End = End.new()
var sense: Sense = Sense.new()

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
	font.set_size(FONT_SIZE)
	board.setup(Rect2(Vector2.ZERO, screen_size), load("res://assets/board1.png"))
	setting.setup(Rect2(30,30, 100, 100))
	end.setup(Rect2(screen_size.x - 500, screen_size.y * 0.5, 300, 300))
	
	var player_id := "Client"
	sense.set_this_player_id(player_id)
	players[player_id] = Player.new(true, player_id, screen_size,
	 null, $Arrow, Vector2(20, 20))
	player_id = "Opp"
	players[player_id] = Player.new(false, player_id, screen_size,
	 null, $Arrow, Vector2(20, 20))
	
	var curve = $Path2D.curve
	for i in range(curve.get_point_count()):
		print(
			"point: ", curve.get_point_position(i),
			"\n in: ", curve.get_point_in(i),
			"\n out: ", curve.get_point_out(i)
		)

func _input(event: InputEvent):
#	if sense.prev_view_id() != Sense.None:
#		get_view(sense.prev_player_id(), sense.prev_view_id())._mouse_exit(sense)
#		sense.set_prev_view_id_none()
	var mouse_pos: Vector2 = \
		event.position \
		if event is InputEventMouseMotion \
		else sense.mouse_pos()
	var clicked: bool = \
		event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed
	sense.set_input(mouse_pos, clicked)
	sense.send_action(Sense.MouseMove)

func get_drag_data(position: Vector2):
	if sense.player_id() == sense.this_player_id() and sense.card_id() > -1:
		if sense.view_id() == Sense.Hand:
			players.get(sense.this_player_id()).hand.select_card(sense.card_id())
			sense.start_drag()
			return { id = "drag" }
		if sense.view_id() == Sense.L_Tabel or sense.view_id() == Sense.R_Tabel:
#		if sense.view_id() == Sense.Tabel:
			#arrow
			players.get(sense.this_player_id()).tabel.select_card(sense)
			sense.start_targeting()
			return { id = "drag" }
#func release_left_mouse_button():
#    var a = InputEventMouseButton.new()
#    a.set_button_index(1)
#    a.set_pressed(false)
#    Input.parse_input_event(a)
#	return null

func can_drop_data(position: Vector2, data) -> bool:
	return true

func drop_data(position: Vector2, data) -> void:
	if sense.drag_view_id() == Sense.Hand:
		if sense.player_id() == sense.this_player_id():
			if sense.view_id() == Sense.Hand:
				var player: Player = players.get(sense.this_player_id())
				var card: Card = player.hand.remove_select_card()
				card.set_visible(true)
				player.hand.add_card(card, sense.card_id())
			
			elif sense.view_id() == Sense.L_Tabel:
				var player: Player = players.get(sense.this_player_id())
				var card: Card = player.hand.remove_select_card()
				card.set_visible(true)
				#TODO: if !is_full
				player.tabel.left_line.add_card(card, sense.card_id())
			elif sense.view_id() == Sense.R_Tabel:
				var player: Player = players.get(sense.this_player_id())
				var card: Card = player.hand.remove_select_card()
				card.set_visible(true)
				#TODO: if !is_full
				player.tabel.right_line.add_card(card, sense.card_id())
		else:
			players.get(sense.this_player_id()).hand.unselect_card()
		sense.stop_drag()
	elif sense.targeting() and sense.drag_view_id() == Sense.L_Tabel or sense.drag_view_id() == Sense.R_Tabel:
		if sense.view_id() == Sense.L_Tabel or  sense.view_id() == Sense.R_Tabel:
			if sense.player_id() != sense.this_player_id():
#				attack
				pass
		else:
			pass
		var player: Player = players.get(sense.this_player_id())
		var card: Card = player.tabel.unselect_card()
		sense.stop_targeting()
		for player_id in players:
			players[player_id].tabel.unhighlight_all_card()

func _process(delta: float):
	for event in sense.event():
		match event:
			#input_event
			Sense.MouseMove:
				if setting.mouse_enter(sense):
					setting.input(sense)
					return
				match active_screen:
					Sense.ScreenMain:
						if end.mouse_enter(sense):
							end.input(sense)
							return
						for player_id in players:
							var player: Player = players.get(player_id)
							#TODO: detect up or down and active or no
							if player.mouse_enter(sense):
								return
#					Sense.ScreenSetting:
					Sense.ScreenDeck:
						var player: Player = players.get(sense.player_id())
						player.deck.screen.input(sense)
						return
#					Sense.ScreenFactorys:
#					Sense.ScreenGraveyard: 
#					Sense.ScreenSecrets:
#					Sense.ScreenCard: 
#					Sense.ScreenTabelCard: 
#					Sense.ScreenAttack:
			Sense.MouseExit:
				pass
			Sense.ScreenDeck:
				var player: Player = players.get(sense.player_id())
				var deck: Deck = player.deck
				scroll_container.setup(deck._cards)
			Sense.Cast:
				pass
			Sense.Attack:
				pass
			Sense.ShiftinHand:
				pass
			#network_event
	sense.event().clear()
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
	if sense.targeting():
		player.tabel.targeting_arrow(screen_size, sense.mouse_pos())
#	Render.buttom(self, "Hello", 150, Rect2(0,0, 400, 400))
#	Render.setting_menu(self, 150, Rect2(400, 400, 400, 400), Rect2(450, 450, 250, 250), 10)
#	Render.shadowing(self, screen_size)
#	var card: Card = player.hand.get_card(4)
#	var def_pos := card.position()
#	var def_pot := card.rotation()
#	card.set_position(Vector2(200, 200)) 
#	card.set_rotation(0) 
#	Render.draw_card(self, card, Vector2(700, 700))
#	card.set_position(def_pos) 
#	card.set_rotation(def_pot) 

####Render
func draw_hovered(rect: Rect2, hovered: bool, clicked: bool):
	self.draw_rect(rect, self.CLICKED_COLOR if clicked else self.HOVER_COLOR, false, self.HOVER_LIZE_SIZE)

func draw_buttom(text: String, font_size: int, rect: Rect2, texture: Texture = load("res://assets/error.png") as Texture):
#	ctx.draw_texture_rect(texture, rect, false)
	self.draw_rect(rect, Color.violet)
	self.font.set_size(font_size)
	var h_font_size = font_size * 0.5
	self.draw_string(self.font, rect.get_center() - self.font.get_string_size(text) * 0.5 + Vector2(0, h_font_size), text)

#func draw_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#	var buttom_count := 3
#	var y_offset := margin.size.y + indent
#	var brect := Rect2(margin.position, Vector2(margin.size.x, margin.size.y / buttom_count - indent))
#	ctx.draw_rect(rect, Color.brown)
#	buttom(ctx, "Play", font_size, brect)
#	brect.position.y += y_offset
#	buttom(ctx, "Setting", font_size, brect)
#	brect.position.y += y_offset
#	buttom(ctx, "Exit", font_size, brect)

#var _max_row_count := 9
#var _row_count := 0
#var _card_size := Vector2(200, 200)
#var _card_indent := Vector2(10, 10)
#func deck(ctx: CanvasItem, cards: Array, max_row_count: int):
#	var current_row_count := 0
#	var _last_colum_count = cards.size() % max_row_count
#	if _last_colum_count == 0:
#		_row_count += 1
##		rect_min_size = Vector2(1000, 1000)
#	var pos := _card_indent + (_card_size + _card_indent) \
#	 * Vector2(_last_colum_count, _row_count) - Vector2(0, _card_size.y)
#	if pos.y + _card_size.y + _card_indent.y > rect_min_size.y:
#		rect_min_size.y += _card_size.y + _card_indent.y
#	card.set_position(pos)
#	add_child(card)

#func take_card_screen(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#				ctx.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), card.highlight_color(), false, 15)
#	for i in range(3):
#		draw_card(ctx, card, card_size)

func draw_shadowing():
	self.draw_rect(Rect2(Vector2.ZERO, self.screen_size), Color(0,0,0, 0.5))

func draw_zoom_card(card: Card, card_size: Vector2):
	self.draw_card(card, card_size)

func draw_card(card: Card, card_size: Vector2):
	if card.visible():
		var card_pivot := card_size * 0.5 #* _scale
		self.draw_set_transform(card.position() + card_pivot, card.rotation(), card.scale())
		self.draw_texture_rect(card.texture(), Rect2(Vector2.ZERO - card_pivot, card_size), false)
		#	ctx.draw_rect()
		#	ctx.draw_string()
		if card.highlight():
			self.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), card.highlight_color(), false, 15)
