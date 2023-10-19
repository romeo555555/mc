extends Control

onready var scroll_container: Control = $ScrollContainer/Control
onready var arrow: Line2D = $Arrow
var active_screen: int = Sense.ScreenMain
#var screen_size := Vector2(1980, 1080)
var setting: Setting = Setting.new()
var board: Board = Board.new()
#board in
var players: Dictionary = {}
var end: End = End.new()
var sense: Sense = Sense.new()

var modal_attack = ModalAttack.new()
var modal_card = ModalCard.new()
var modal_card_on_tabel = ModalCardOnTabel.new()
var modal_choose_card = ModalChooseCard.new()


#263e33
func _ready() -> void:
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
	Physics2DServer.set_active(false)
	PhysicsServer.set_active(false)

	setting.font.font_data = load("res://assets/font/SansSerif.ttf")
	setting.font.set_size(setting.font_size)
	
	board.box.init(Vector2.ZERO, setting.screen_size)
	board.texture = load("res://assets/board1.png") as Texture
	
	setting.init(Vector2(30,30), Vector2(100, 100))
#	setting.modal.init(screen_size, Vector2(700, 700), Vector2(100, 100))
	end.init(Vector2(setting.screen_size.x - 500, setting.screen_size.y * 0.5), Vector2(300, 300))
#	end.modal.init(screen_size, Vector2(900, 300), Vector2(200, 200))
#	sd.init(screen_size, Vector2(700, 700), Vector2(100, 100))
	
	var player_id := "Client"
	sense.set_this_player_id(player_id)
	players[player_id] = Player.new(true, player_id, setting.screen_size,
	 null, $Arrow, Vector2(20, 20))
	player_id = "Opp"
	players[player_id] = Player.new(false, player_id, setting.screen_size,
	 null, $Arrow, Vector2(20, 20))
	
	scroll_container.init(setting.screen_size, Vector2(100, 100), Vector2(200, 200))
	scroll_container.setup(players.get(sense.this_player_id()).deck._cards)
#	for id in players:
#		var player: Player = players.get(id)
#		player.deck.connect("screen", self, "on_deck_screen")
	
	var curve = $Path2D.curve
	for i in range(curve.get_point_count()):
		print(
			"point: ", curve.get_point_position(i),
			"\n in: ", curve.get_point_in(i),
			"\n out: ", curve.get_point_out(i)
		)

func _input(event: InputEvent) -> void:
	var mouse_pos: Vector2 = \
		event.position \
		if event is InputEventMouseMotion \
		else sense.mouse_pos()
	var clicked: bool = \
		event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed
	sense.set_input(mouse_pos, clicked)
#	while !sense.actions.empty():
#		var action: int = sense.actions.pop_back()
#		match action:
#			#input_event
#			Sense.ScreenDeck:
#				var player: Player = players.get(sense.player_id())
#				var deck: Deck = player.deck
#				scroll_container.setup(deck._cards)
#			Sense.Cast:
#				pass
#			Sense.Attack:
#				pass
#			Sense.ShiftinHand:
#				pass
			#network_event
	match setting.box.input(sense):
		Sense.Enter: setting.box.set_hovered(true)
		Sense.Exit: setting.box.set_hovered(false)
		Sense.Click: sense.send_action(Sense.ScreenSetting)
		_: pass
	match active_screen:
		Sense.ScreenMain:
			match end.box.input(sense):
				Sense.Enter: end.box.set_hovered(true)
				Sense.Exit: end.box.set_hovered(false)
				Sense.Click: pass
				_: pass
			for player_id in players:
				var player: Player = players.get(player_id)
				#TODO: detect up or down and active or no
				player.input(sense)
		Sense.ScreenDeck:
			var player: Player = players.get(sense.player_id())
			player.deck.screen.input(sense)
#					Sense.ScreenFactorys:
#					Sense.ScreenGraveyard: 
#					Sense.ScreenSecrets:
#					Sense.ScreenCard: 
#					Sense.ScreenTabelCard: 
#					Sense.ScreenAttack:

func get_drag_data(position: Vector2):
	if active_screen != Sense.ScreenMain:
		return null
	
	var player: Player = players.get(sense.this_player_id())
	var hand: Hand = player.hand
	var focused_card: int = hand.focused_card()
	if focused_card > -1:
		hand.cached_card(focused_card)
		sense.start_drag()
		return { id = "drag" }
	var left_tabel: Line = player.left_tabel
	var lfocused_card: int = left_tabel.focused_card()
	if lfocused_card > -1:
		left_tabel.cached_card(focused_card)
		sense.start_targeting()
		return { id = "target" }
	var right_tabel: Line = player.right_tabel
	var rfocused_card: int = right_tabel.focused_card()
	if rfocused_card > -1:
		right_tabel.cached_card(focused_card)
		sense.start_targeting()
		return { id = "target" }
	
#	if sense.player_id() == sense.this_player_id() and sense.card_id() > -1:
#		if sense.view_id() == Sense.Hand:
#			players.get(sense.this_player_id()).hand.select_card(sense.card_id())
#			sense.start_drag()
#			return { id = "drag" }
#		if sense.view_id() == Sense.L_Tabel or sense.view_id() == Sense.R_Tabel:
##		if sense.view_id() == Sense.Tabel:
#			#arrow
#			players.get(sense.this_player_id()).tabel.select_card(sense)
#			sense.start_targeting()
#			return { id = "drag" }

func can_drop_data(position: Vector2, data) -> bool:
	#TODO add 2  and 3 to box input return (dragging and targeting)
	var player: Player = players.get(sense.this_player_id())
	var left_tabel: Line = player.left_tabel
#	if left_tabel.box.is_focused():
	var right_tabel: Line = player.right_tabel
#	if right_tabel.box.is_focused():

#	if sense.targeting():
#		arrow.clear_points()
#		var curve = Curve2D.new()
#		curve.add_point(
#				_cached_start_pos,
#		#			screen_size/2,
#				Vector2(0,0),
#		#			TODO:
#		#			(board._rect.size/2).direction_to(get_viewport().size/2) * 75)
#				(screen_size/2).direction_to(screen_size/2) * 75)
#		curve.add_point(mouse_pos,
#				Vector2(0, 0), Vector2(0, 0))
#		arrow.set_points(curve.get_baked_points())
	return true

func drop_data(position: Vector2, data) -> void:
	pass
#	if sense.drag_view_id() == Sense.Hand:
#		if sense.player_id() == sense.this_player_id():
#			if sense.view_id() == Sense.Hand:
#				var player: Player = players.get(sense.this_player_id())
#				var card: Card = player.hand.remove_select_card()
#				card.set_visible(true)
#				player.hand.add_card(card, sense.card_id())
#
#			elif sense.view_id() == Sense.L_Tabel:
#				var player: Player = players.get(sense.this_player_id())
#				var card: Card = player.hand.remove_select_card()
#				card.set_visible(true)
#				#TODO: if !is_full
#				player.tabel.left_line.add_card(card, sense.card_id())
#			elif sense.view_id() == Sense.R_Tabel:
#				var player: Player = players.get(sense.this_player_id())
#				var card: Card = player.hand.remove_select_card()
#				card.set_visible(true)
#				#TODO: if !is_full
#				player.tabel.right_line.add_card(card, sense.card_id())
#		else:
#			players.get(sense.this_player_id()).hand.unselect_card()
#		sense.stop_drag()
#	elif sense.targeting() and sense.drag_view_id() == Sense.L_Tabel or sense.drag_view_id() == Sense.R_Tabel:
#		if sense.view_id() == Sense.L_Tabel or  sense.view_id() == Sense.R_Tabel:
#			if sense.player_id() != sense.this_player_id():
##				attack
#				pass
#		else:
#			pass
#		var player: Player = players.get(sense.this_player_id())
#		var card: Card = player.tabel.unselect_card()
#		sense.stop_targeting()
#		for player_id in players:
#			players[player_id].tabel.unhighlight_all_card()

func _process(delta: float) -> void:
	update()
#	scroll_container.update()
#	if sense.targeting():
#		sense.aim()

func on_setting_screen():
	pass
func on_avatar_screen():
	print("YES")
func on_card_screen():
	pass
func on_tabel_card_screen():
	pass
func on_attack_screen():
	pass
func on_deck_screen():
	pass
func on_factory_screen():
	pass
func on_graveyard_screen():
	pass
func on_secrets_screen():
	pass
func on_take_screen():
	pass

func _draw() -> void:
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
		player.tabel.targeting_arrow(setting.screen_size, sense.mouse_pos())
#	setting.modal.draw(self)
#	end.modal.draw(self)
	scroll_container.update()

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
func draw_hovered(box: Box) -> void:
	if box.is_hovered():
		draw_rect(box.rect(), setting.clicked_color if box.is_clicked() else setting.hover_color, false, setting.hover_line_size)

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

func draw_shadowing() -> void:
	draw_rect(Rect2(Vector2.ZERO, setting.screen_size), Color(0,0,0, 0.5))
