#tool
extends Control

var screen_size := Vector2(1980, 1080)
var board: View = View.new()
var setting: View = View.new()
var end: View = View.new()
var players: Dictionary = {}
var this_player_id: String

var _texture: Texture
var _rect: Rect2
#var _data

var _clicked := false
var _hovered := false
var _drag := false
var _dragging := false
var _drop := false
var _select_prev_card_id: int
var _select_card_id: int
var _select_line_id: int
var _select_player_id: int
var _select_rect: Rect2

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
	setup_player("Client", true)
	setup_player("Opp")

func setup_player(player_id: String, is_this_player: bool = false):
#	var id := player_id.hash()
	var width: float = 1980
	var height: float = 1080
	var half_height: float = height * 0.5
	var player := Player.new()
	if is_this_player:
		this_player_id = player_id
		player.setup(Rect2(0.0, half_height, width, half_height), Vector2(20, 20), true)
	else:
		player.setup(Rect2(0.0, 0.0, width, half_height), Vector2(20, 20))
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

	players[player_id] = player
	print("Add player", player_id)
	print(players.size())

func _input(event: InputEvent):
	_clicked = event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT and event.pressed
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		if setting.has_point(mouse_pos):
			handler_setting()
		elif end.has_point(mouse_pos):
			handler_end()
		else:
			for player_id in players:
				select_player = player_id
#				print("player_id: ", player_id)
				var player: Player = players[player_id]
				if player.has_point(mouse_pos):
					if player.factorys.has_point(mouse_pos):
						handler_factorys()
					elif player.secrets.has_point(mouse_pos):
						handler_secrets()
					elif player.graveyard.has_point(mouse_pos):
						handler_graveyard()
					elif player.deck.has_point(mouse_pos):
						handler_deck()
					elif player.tabel.avatar.has_point(mouse_pos):
						handler_avatar()
					elif player.hand.has_point(mouse_pos):
						var card_id := player.tabel.has_point_on_card(mouse_pos)
						if card_id > -1:
							handler_hand_card(card_id)
						else:
							handler_hand()
					elif player.tabel.has_point(mouse_pos):
						var card_id := player.tabel.has_point_on_card(mouse_pos)
						if card_id > -1:
							handler_tabel_card(card_id)
						else:
							handler_tabel()
					else:
						handler_none()

func _process(delta):
	update()

func _draw():
	board.draw(self)
#	setting.draw(self)
#	end.draw(self)
	for player_id in players:
		var player: Player = players[player_id]
		player.draw(self)
	if select_card:
		draw_rect(_cached_rect, Color.aquamarine, false, 10)

func get_drag_data(position: Vector2):
	_drag = true
	return { id = "foobar" }

func can_drop_data(position: Vector2, data) -> bool:
	return true

func drop_data(position: Vector2, data) -> void:
	_drop = true
	pass

func handler_avatar():
	print("avatar")
	pass
func handler_hand():
	print("hand")
	pass
func handler_tabel():
	print("tabel")
	pass
var select_card:=false
var _cached_rect:= Rect2(0,0,0,0)
var select_player:String
func handler_tabel_card(card_id: int):
	print("tabel: ", card_id)
#	select_card = true
#	_cached_rect = Rect2(players[select_player].tabel._cards[card_id].position(), Vector2(200, 200))
	
	pass
func handler_hand_card(card_id: int):
	print("hand: ",card_id)
	pass 
func handler_factorys():
	print("fact")
	pass
func handler_graveyard():
	print("grave")
	pass
func handler_secrets():
	print("secret")
	pass
func handler_deck():
	print("deck")
	pass
func handler_setting():
	pass
func handler_end():
	pass
func handler_none():
	pass
