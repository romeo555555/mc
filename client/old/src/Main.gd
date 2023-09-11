extends Control

#const proto: Reference = preload("res://protos/buff.gd")
#const gui: Reference = preload("res://src/gui.gd")
#const Client: Reference = preload("res://src/client.gd")
#const fab_deck: PackedScene = preload("res://scn/Deck.tscn")
#const card_prefab: PackedScene = preload("res://src/Card.tscn")


#var client: Client = Client.new($NakamaHTTPAdapter, $NakamaWebSocketAdapter)

var screen_size := Vector2(1980, 1080) 
var screen_center := screen_size * 0.5 
var card_size := Vector2(200, 200) 
var card_indent := Vector2(10, 0) 
var gui_setting: Rect2
var gui_end: Rect2
#var gui_client: GuiPlayer = GuiPlayer.new()
#var gui_opp: GuiPlayer = GuiPlayer.new()
#var select: Select = Select.new()

#var guit: int = GUIT.NONE
#var pid: int = PID.NONE
#var action: int = Action.NONE
#var select_node = null #need only for hovered_vible_on
#var card_selected: = false
#var card_target: = false
#var select_card_id: = 0
#var target_card_id: = 0
#var cached_hovered_rect: Rect2
#enum Aligment { CENTER, START, END }
#enum Action { NONE, CLICK, HOVER, DRAG, DRAGGING, DROP }
#enum GUIT { NONE, HAND, R_TABEL, L_TABEL, DECK, AVATAR, BUILD, SETTING, END }
#enum PID { NONE, CLIENT, OPP }


enum ComponentID { 
	NONE, HAND, HAND_CARD, 
	R_TABEL, R_TABEL_CARD, R_TABEL, R_TABEL_CARD,
	AVATAR, BUILDS, TRAPS, DEAD, DECK, SETTING, END 
}
var players: Dictionary = {}
var this_player_id: int

var _clicked := false
var _hovered := false
var _dragging := false
var _select_prev_card_id: int
var _select_card_id: int
var _select_line_id: int
var _select_player_id: int
var _select_rect: Rect2

func set_select_card(player_id: int, line_id: int, card_id: int):
	_select_prev_card_id = _select_player_id
	_select_player_id = player_id
	_select_line_id = line_id
	_select_card_id = card_id

func select_card() -> Node:
	return get_player(_select_player_id).get_line(_select_line_id).get_card(_select_card_id) 

func get_player(player_id: int) -> Node:
	return players.get(player_id)

func set_hovered():
	if _hovered:
		get_child(_select_prev_card_id).get_child(0).set_visible(false)
	select_card().get_child(0).set_visible(true)
	_hovered = true

func check_hovered(mouse_pos: Vector2):
	if _hovered and not _select_rect.has_point(mouse_pos):
		hovered_off()

func hovered_off():
	select_card().get_child(0).set_visible(false)
	_hovered = false

signal input_event(player_id, component_id, card_id)
#auth
#matchmeker
#matchrequest
#join
#server state
#godo_theme_color #265036
#default_color = Color.aqua
#$ArrowHead.color = Color.aquamarine
#use_parent_material
func init_player(player_id: int, player: Node):
#	player
	players[player_id] = player
var textures: Array
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
	
	this_player_id = "Client".hash()
	init_player(this_player_id, $Board/Player1)
	init_player("Opp".hash(), $Board/Player2)
	
#	set_layout(Vector2(1980, 1080))
#	$Board/ClientAvatar.connect("pressed", self, "_on_Avatar_pressed")
#	$Board/ClientBuild.connect("pressed", self, "_on_Build_pressed")
#	$Board/ClientDeck.connect("pressed", self, "_on_Deck_pressed")
#	$Board/ClientTabel.connect("pressed", self, "_on_Tabel_pressed")
#	$Board/ClientHand.connect("pressed", self, "_on_Hand_pressed")
	
#	$Board/OppAvatar.connect("pressed", self, "_on_Avatar_pressed")
#	$Board/OppBuild.connect("pressed", self, "_on_Build_pressed")
#	$Board/OppDeck.connect("pressed", self, "_on_Deck_pressed")
#	$Board/OppTabel.connect("pressed", self, "_on_Tabel_pressed")
#	$Board/OppHand.connect("pressed", self, "_on_Hand_pressed")
	
	$Board/Setting.connect("pressed", self, "_on_Setting_pressed")
	$Board/End.connect("pressed", self, "_on_End_pressed")
#	$Board/ClientSide.tabel.connect("click_on_card", self, "_on_Card_pressed", [x, y], CONNECT_DEFERRED)
	
	for i in range(5):
		var card = card_prefab.instance()
		$Board/Player1.hand.add_card(card)
	for i in range(2):
		var card = card_prefab.instance()
		$Board/Player1.tabel.cast_right(card)
	for i in range(2):
		var card = card_prefab.instance()
		$Board/Player1.tabel.cast_left(card)
#	var node := $Board/BuildScreen/Control
#	for i in range(60):
#		var card = card_prefab.instance()
#		node.add_card(card)
#	for i in range(100):
#		var card = card_prefab.instance()
#		add_child(card)
#	for i in range(100):
#		var t: Texture = load("res://assets/av1.png")
#		textures.append(t)
#
#func _process(delta):
#	update()
#
#
#func _draw():
#	var p:=10.0
#	for t in textures:
#		draw_rect(Rect2(p, 0, 300, 300), Color.aqua)
#		draw_texture_rect(t, Rect2(p, 0, 300, 300), false)
#		p += p
#	pass
#	var _card_size := Vector2(200, 300)
#	var _card_indent := Vector2(10, 0)
#	var children := node.get_children()
#	var count := children.size()
#	var offset := _card_size.x + _card_indent.x
#	var start_x := (count * offset - _card_indent.x) * -1
##	var x := (start_x) * 0.5
#	var x := 0
#	for i in range(count):
#		print("xx", x)
##		node.fit_child_in_rect( children[i], Rect2( Vector2(x, 0), _card_size ) )
#		children[i].set_position(Vector2(x, 0))
#		x += offset

var x := 0
var y := 0
#func _on_Card_pressed(x: int, y: int):
func _on_Card_pressed(x2: int, y2: int, x3: int, y3: int):
	print("do ", x, " ", y)
	print("do2 ", x2, " ", y2)
	print("do3 ", x3, " ", y3)
#	var card = card_prefab.instance()
#	$Board/ClientSide.hand().add_card(card)
func callback_avatar():
	pass
func callback_tabel():
	pass

func callback_tabel_card(player_id: int, line_id: int, card_id: int):
	set_select_card(player_id, line_id, card_id)
#	var card: Node = select_card()
	if _clicked:
		pass
	#hover
	set_hovered()

func callback_hand_card(player_id: int, line_id: int, card_id: int):
	set_select_card(player_id, line_id, card_id)
#	var card: Node = select_card()
	if _clicked:
		pass
	#hover
	set_hovered()

func callback_hand():
	pass
func callback_builds():
	pass
func callback_traps():
	pass
func callback_dead():
	pass
func callback_deck():
	pass
func _on_Avatar_pressed():
	print("av press") 
func _on_Deck_pressed():
	print("deck press") 
func _on_Build_pressed():
	print("build press") 
func _on_Tabel_pressed():
	print("tabelpress") 
func _on_Hand_pressed():
	print("hand press") 
func _on_Setting_pressed():
	print("setting press") 
func _on_End_pressed():
	print("end press") 


func _input(event: InputEvent):
	_clicked = event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT and event.pressed
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		check_hovered(mouse_pos)
		if _dragging:
			var arrow := $Board/Arrow
			arrow.clear_points()
			var curve = Curve2D.new()
			curve.add_point(get_rect().size/2,
					Vector2(0,0),
					(get_rect().size/2).direction_to(get_viewport().size/2) * 75)
			curve.add_point(mouse_pos,
					Vector2(0, 0), Vector2(0, 0))
			arrow.set_points(curve.get_baked_points())
#	client = Client.new($NakamaHTTPAdapter, $NakamaWebSocketAdapter)
#	client.socket.connect("received_matchmaker_matched", self, "_on_matchmaker_matched")
##	socket.connect("received_match_state", _on_match_state)
#	client.run_matchmaker()

#	for i in range(3):
#		var card = fab_hand_card.instance()
#		add_child(card)
#		var id = card.get_instance_id()
#		gui_client.hand_cards.append(card)
#
#		var tcard = fab_tabel_card.instance()
#		add_child(tcard)
#		var tid = tcard.get_instance_id()
#		gui_client.l_tabel_cards.append(tcard)
		
#		var otcard = fab_tabel_card.instance()
#		add_child(otcard)
#		var otid = otcard.get_instance_id()
#		state.opp.tabel[tid] = otcard
	
#	line_aligment(gui_client.l_tabel.position, gui_client.l_tabel_cards, Aligment.END)
#	line_aligment(gui_client.hand.position, gui_client.hand_cards)
#	aligment(state, Gui.CLIENT, Gui.HAND)
#	aligment(state, Gui.CLIENT, Gui.TABEL)
#	aligment(state, Gui.OPP, Gui.TABEL)
#func _gui_input(event: InputEvent):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed: set_clicked()
#	if event is InputEventMouseMotion:
#		var mouse_pos: Vector2 = event.position
#
#func get_drag_data(position: Vector2):
#	if is_card_select():
#		if guit == GUIT.HAND:
#			set_dragging()
#			var preview = gui_client.l_tabel_cards[select_card_id].duplicate()
#			set_drag_preview(preview)
#			return { id = "foobar" } #, card = select_node
#		if guit == GUIT.L_TABEL || guit == GUIT.R_TABEL:
#			set_dragging()
#			$ArrowLine.show()
#			$ArrowLine.set_point_position(0, position)
#			$ArrowLine.set_point_position(1, position)
#			var preview = $Arrow
#			preview.set_visible(true)
#			set_drag_preview(preview.duplicate())
#			preview.set_visible(false)
#			return { id = "foobar", card = select_node }
#
#func can_drop_data(position: Vector2, data) -> bool:
#	return true
#
#func drop_data(position: Vector2, data) -> void:
##	if is_hovered():
##		if guit == GUIT.HAND:
##		if guit == GUIT.TABEL:
#	clear_action()
#	$ArrowLine.hide()
#	var card = gui_client.l_tabel_cards[select_card_id].duplicate()
#	var tween = get_node("Tween")
#	tween.interpolate_method(card, "set_position",
#			Vector2(0, 0), position, 1,
#			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
#


#func _on_matchmaker_matched(p_matched : NakamaRTAPI.MatchmakerMatched):
#	#if accept
#	client.join_to_match(p_matched)
