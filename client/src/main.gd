extends Control

enum Screen { 
	Main,
	Setting
}
var ctx: Context
var active_screen: int = Screen.Main
var arrow_pos: Vector2 = Vector2.ZERO
var board: Board
var card: Card

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
	
#	var tween = get_tree().create_tween()
	ctx = Context.new($Arrow, $Tween)
	board = Board.new(self, ctx)
	card = Card.new(ctx)
#	$ScrollContainer/Control.config = config
#	board.init($ScrollContainer/Control)
#	board.texture = load("res://assets/board1.png") as Texture
	
	
#	scroll_container.init(setting.screen_size, Vector2(100, 100), Vector2(200, 200))
#	scroll_container.setup(players.get(sense.this_player_id()).deck._cards)

#	setting.modal.init(screen_size, Vector2(700, 700), Vector2(100, 100))
#	end.modal.init(screen_size, Vector2(900, 300), Vector2(200, 200))
#	sd.init(screen_size, Vector2(700, 700), Vector2(100, 100))
	
#	for id in players:
#		var player: Player = players.get(id)
#		player.deck.connect("screen", self, "on_deck_screen")
	
#	var curve = $Path2D.curve
#	for i in range(curve.get_point_count()):
#		print(
#			"point: ", curve.get_point_position(i),
#			"\n in: ", curve.get_point_in(i),
#			"\n out: ", curve.get_point_out(i)
#		)

func _input(event: InputEvent) -> void:
	ctx.set_input(event)
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
			
			
#	match active_screen:
#		Screen.Main:
#			board.input(sense)
#		Screen.Setting:
#			pass
##			setting.input(sense)

func get_drag_data(position: Vector2):
#	print("drag222")
	return Card.new(ctx)
	# Card.new(ctx)
#	if active_screen != Screen.Main:
#		return null
#	var player: Player = board.this_player()
#	if player.hand.has_focused_card():
#		player.hand.cached_card(player.hand.get_focused_card_id())
#		sense.start_drag()
#		return { id = "drag" }
#	if player.tabel.has_focused_card():
#		player.tabel.cached_card(player.tabel.get_focused_card_id())
##		arrow_pos
#		sense.start_targeting()
#		return { id = "target" }


func can_drop_data(position: Vector2, data) -> bool:
	print("drag")
#	#TODO add 2  and 3 to box input return (dragging and targeting)
#	if sense.dragging():
#		var player: Player = board.this_player()
#		if player.tabel.has_focused_card():
#			#card is Unit
#			#TODO focus but dont exit
#			player.tabel.left_list.aligment_line()
#			player.tabel.right_list.aligment_line()
#			player.tabel.casting(sense.mouse_pos())
#
#	if sense.targeting():
#		var player: Player = board.get_player(sense.player_id())
#		if player.tabel.has_focused_card():
#			#card is Unit
#			#TODO focus but dont exit
#			player.tabel.focused_card(sense.mouse_pos())
#
#		arrow.clear_points()
#		var curve = Curve2D.new()
#		curve.add_point(
#				arrow_pos,
#		#			screen_size/2,
#				Vector2(0,0),
#		#			TODO:
#		#			(board._rect.size/2).direction_to(get_viewport().size/2) * 75)
#				(config.screen_size/2).direction_to(config.screen_size/2) * 75)
#		curve.add_point(sense.mouse_pos(),
#				Vector2(0, 0), Vector2(0, 0))
#		arrow.set_points(curve.get_baked_points())
	return true

func drop_data(position: Vector2, data) -> void:
	print("drop")
	pass
#	if sense.dragging():
#		var player: Player = board.this_player()
#		if player.hand.has_focused_card():
#			var card: Card = player.hand.remove_cached_card()
#			card.set_visible(true)
#			player.hand.add_card(card, player.hand.get_focused_card_id())
#		elif player.tabel.has_focused_card():
#			#TODO focus but dont exit
#			var card: Card = player.hand.remove_cached_card()
#			card.set_visible(true)
##			#TODO: if !is_full
#			player.tabel.add_card_to_focus(card)
#		else:
#			player.hand.uncached_card()
#		sense.stop_drag()
#
#	if sense.targeting():
#		var player: Player = board.get_player(sense.player_id())
#		if player.is_this_player:
#			pass
#		else:
#			pass
#			#attck
#		sense.stop_targeting()
#
##	elif sense.targeting() and sense.drag_view_id() == Sense.L_Tabel or sense.drag_view_id() == Sense.R_Tabel:
##		if sense.view_id() == Sense.L_Tabel or  sense.view_id() == Sense.R_Tabel:
##			if sense.player_id() != sense.this_player_id():
###				attack
##				pass
##		else:
##			pass
##		var player: Player = players.get(sense.this_player_id())
##		var card: Card = player.tabel.unselect_card()
##		sense.stop_targeting()
##		for player_id in players:
##			players[player_id].tabel.unhighlight_all_card()

func _process(delta: float) -> void:
	ctx.delta = delta
	update()
#	scroll_container.update()
#	if sense.targeting():
#		sense.aim()

func _draw() -> void:
	ctx.set_canvas(self)
#	card.draw(ctx, Vector2(200, 200))
#	card.set_position(card.position()+Vector2.ONE)
#	card.set_rotation(card.rotation()+0.3)
#	card.set_scale(card.scale() + Vector2(0.0001, 0.0001))

#	setting.draw(self)
	board.render(ctx)
#	if sense.dragging():
#		board.draw_dragging(self, sense.mouse_pos())
	ctx.set_canvas(null)

####Render
#func draw_shadowing() -> void:
#	draw_rect(Rect2(Vector2.ZERO, config.screen_size), Color(0,0,0, 0.5))
