#tool
extends Control

var screen_size := Vector2(1980, 1080)
var select: Select = Select.new()
var font = DynamicFont.new()
#var font = get_font("font")


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
	select.set_arrow($Arrow)
	select.board.setup(Rect2(Vector2.ZERO, screen_size), load("res://assets/board1.png"))
	select.setting.setup(Rect2(30,30, 100, 100))
	select.end.setup(Rect2(screen_size.x - 500, screen_size.y * 0.5, 300, 300))
	var state: Dictionary = {}
	setup_player(state, "Opp")
	setup_player(state, "Client", true) #render this_player last/top
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
		player.tabel.add_card(card, false)
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		player.tabel.add_card(card, true)
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
	select.input( \
		event.position \
		if event is InputEventMouseMotion \
		else select.mouse_pos(),
		event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed
	)

func _process(delta):
	if select.targeting():
		select.aim()
	update()

func _draw():
	select.board.draw(self, font)
#	select.setting.draw(self)
#	select.end.draw(self)
	for player_id in select.state():
		var player: Player = select.player(player_id)
		player.draw(self, font)
	if select.casting():
		select.draw(self, font)
#	if select_card:
#		draw_rect(_cached_rect, Color.aquamarine, false, 10)
#	if card:
#		card.set_position(mouse_pos)
#		card.draw(self, Vector2(200, 200))

func get_drag_data(position: Vector2):
	select.start_drag()
	return { id = "foobar" }

func can_drop_data(position: Vector2, data) -> bool:
	return select.dragging()

func drop_data(position: Vector2, data) -> void:
	select.start_drop()
