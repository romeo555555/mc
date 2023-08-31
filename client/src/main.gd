extends Control

#const proto: Reference = preload("res://protos/buff.gd")
const gui: Reference = preload("res://src/gui.gd")
const Client: Reference = preload("res://src/client.gd")
const fab_hand_card: PackedScene = preload("res://scn/HandCard.tscn")
const fab_tabel_card: PackedScene = preload("res://scn/TabelCard.tscn")
const fab_build: PackedScene = preload("res://scn/Build.tscn")
const fab_deck: PackedScene = preload("res://scn/Deck.tscn")

#var client: Client = Client.new($NakamaHTTPAdapter, $NakamaWebSocketAdapter)

var screen_size := Vector2(1980, 1080) 
var screen_center := screen_size * 0.5 
var card_size := Vector2(200, 200) 
var card_indent := Vector2(10, 0) 
var gui_setting: Rect2
var gui_end: Rect2
var gui_client: GuiPlayer = GuiPlayer.new()
var gui_opp: GuiPlayer = GuiPlayer.new()
var select: Select = Select.new()

var guit: int = GUIT.NONE
var pid: int = PID.NONE
var action: int = Action.NONE
var select_node = null #need only for hovered_vible_on
var card_selected: = false
var card_target: = false
var select_card_id: = 0
var target_card_id: = 0
var cached_hovered_rect: Rect2
enum Aligment { CENTER, START, END }
enum Action { NONE, CLICK, HOVER, DRAG, DRAGGING, DROP }
enum GUIT { NONE, HAND, R_TABEL, L_TABEL, DECK, AVATAR, BUILD, SETTING, END }
enum PID { NONE, CLIENT, OPP }
	
func is_hovered() -> bool:
	return action == Action.HOVER

func is_dragging() -> bool:
	return action == Action.DRAGGING

func is_clicked() -> bool:
	return action == Action.CLICK

func is_card_select() -> bool:
	return card_selected

func is_card_target() -> bool:
	return card_target

func set_taget_card(card_id: int):
	card_target = true
	target_card_id = card_id

func set_untarget_card():
	card_target = false

func set_select_card(card_id: int):
	card_selected = true
	select_card_id = card_id

func set_unselect_card():
	card_selected = false

func set_hovered(rect: Rect2, node: Control):
	cached_hovered_rect = rect
	node.get_child(0).set_visible(true)
	select_node = node
	action = Action.HOVER

func set_dragging():
	action = Action.DRAGGING

func set_clicked():
	action = Action.CLICK

func clear_action():
	action = Action.NONE

func check_hovered(mouse_pos: Vector2):
	if action == Action.HOVER:
		if cached_hovered_rect.has_point(mouse_pos):
			print("hovered")
		else:
			action = Action.NONE
			select_node.get_child(0).set_visible(false)
			select_node = null



#auth
#matchmeker
#matchrequest
#join
#server state
#godo_theme_color #265036

func _ready():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
	
	set_layout(Vector2(1980, 1080))


#	client = Client.new($NakamaHTTPAdapter, $NakamaWebSocketAdapter)
#	client.socket.connect("received_matchmaker_matched", self, "_on_matchmaker_matched")
##	socket.connect("received_match_state", _on_match_state)
#	client.run_matchmaker()

	for i in range(3):
		var card = fab_hand_card.instance()
		add_child(card)
		var id = card.get_instance_id()
		gui_client.hand_cards.append(card)
		
		var tcard = fab_tabel_card.instance()
		add_child(tcard)
		var tid = tcard.get_instance_id()
		gui_client.l_tabel_cards.append(tcard)
		
#		var otcard = fab_tabel_card.instance()
#		add_child(otcard)
#		var otid = otcard.get_instance_id()
#		state.opp.tabel[tid] = otcard
	
	line_aligment(gui_client.l_tabel.position, gui_client.l_tabel_cards, Aligment.END)
	line_aligment(gui_client.hand.position, gui_client.hand_cards)
#	aligment(state, Gui.CLIENT, Gui.HAND)
#	aligment(state, Gui.CLIENT, Gui.TABEL)
#	aligment(state, Gui.OPP, Gui.TABEL)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed: set_clicked()
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		check_hovered(mouse_pos)
		#check_drag
		if is_dragging():
			$ArrowLine.set_point_position(1, mouse_pos)
		#contain
		if gui_setting.has_point(mouse_pos):
			guit = GUIT.SETTING
		elif gui_end.has_point(mouse_pos):
			guit = GUIT.END
		else:
			if mouse_pos.y > screen_center.y:
				input_player(gui_client, mouse_pos)
			else:
				print()
#				input_player(gui_client, mouse_pos, true)

func input_player(gui_player: GuiPlayer, mouse_pos: Vector2, mirroring: bool = false):
	pid = gui_player.pid
	if gui_player.deck.has_point(mouse_pos):
		guit = GUIT.DECK
		return
	elif gui_player.build.has_point(mouse_pos):
		guit = GUIT.BUILD
		return
	elif gui_player.avatar.has_point(mouse_pos):
		guit = GUIT.AVATAR
		return
	elif gui_player.l_tabel.has_point(mouse_pos):
		var l_tab_al: int = Aligment.START if mirroring else Aligment.END
		guit = GUIT.L_TABEL
		if is_dragging():
			line_indent_has_point(mouse_pos, gui_player.l_tabel.position, gui_player.l_tabel_cards.size(), l_tab_al)
		else:
			line_card_has_point(mouse_pos, gui_player.l_tabel.position, gui_player.l_tabel_cards.size(), l_tab_al)
		return
	elif gui_player.r_tabel.has_point(mouse_pos):
		var r_tab_al: int = Aligment.END if mirroring else Aligment.START
		guit = GUIT.R_TABEL
		if is_dragging():
			line_indent_has_point(mouse_pos, gui_player.r_tabel.position, gui_player.r_tabel_cards.size(), r_tab_al)
		else:
			line_card_has_point(mouse_pos, gui_player.r_tabel.position, gui_player.r_tabel_cards.size(), r_tab_al)
		return
	else:
		guit = GUIT.HAND
#		if is_dragging():
#		else:
		line_card_has_point(mouse_pos, gui_player.hand.position, gui_player.hand_cards.size())
#		if select_node:
#			drag = false
#			dragging = true
#			set_drag_preview(select_node.duplicate())
#			force_drag({id = "ff"}, select_node.duplicate())
		return

func _process(delta: float):
#		check_if_input_same_how_prev
#		clicked: sort
#		drag
#		dragging: sort from
#		drop: target id
#		hovered
	if guit == GUIT.SETTING:
		if is_clicked():
			$Fog.set_visible(true)
			$SettingMenu.set_visible(true)
		else:
			set_hovered(gui_setting, $Setting)
		return
	if guit == GUIT.END:
		if is_clicked():
			print("end turn")
		else:
			set_hovered(gui_end, $End)
		return
	if pid == PID.CLIENT:
		match guit:
			GUIT.DECK:
				if is_clicked():
					$Fog.set_visible(true)
				else:
					set_hovered(gui_client.deck, $Client/Deck)
			GUIT.BUILD:
				if is_clicked():
					$Fog.set_visible(true)
				else:
					set_hovered(gui_client.build, $Client/Build)
			GUIT.AVATAR:
				if is_clicked():
					$Fog.set_visible(true)
				else:
					set_hovered(gui_client.avatar, $Client/Avatar)
			GUIT.L_TABEL:
#				if is_clicked():
				print()
			GUIT.L_TABEL_CARD:
				var card = gui_client.l_tabel_cards[select_card_id]
				if is_dragging() && is_card_target():
					line_aligment(gui_client.l_tabel.position, gui_client.l_tabel_cards, Aligment.END, true, target_card_id)
				elif is_clicked():
					print()
				else:
					set_hovered(card.get_rect(), card)
			GUIT.R_TABEL:
				print()
			GUIT.HAND:
				print()
#	if pid == PID.OPP:
#		match guit:
#			GUIT.DECK:
#				set_hovered(gui_opp.deck, $Opp/Deck)
#			GUIT.BUILD:
#				set_hovered(gui_opp.build, $Opp/Build)
#			GUIT.AVATAR:
#				set_hovered(gui_opp.avatar, $Opp/Avatar)
#			GUIT.L_TABEL:
#				print()
#			GUIT.R_TABEL:
#				print()
#			GUIT.HAND:
#				print()
	pass

#func _draw():
#	if sense.hovered:
#		print("draw hov")
#		draw_rect(sense.hovered.get_rect(), Color.red, false, 30.0, false)

func get_drag_data(position: Vector2):
	if is_card_select():
		if guit == GUIT.HAND:
			set_dragging()
			var preview = gui_client.l_tabel_cards[select_card_id].duplicate()
			set_drag_preview(preview)
			return { id = "foobar" } #, card = select_node
		if guit == GUIT.L_TABEL || guit == GUIT.R_TABEL:
			set_dragging()
			$ArrowLine.show()
			$ArrowLine.set_point_position(0, position)
			$ArrowLine.set_point_position(1, position)
			var preview = $Arrow
			preview.set_visible(true)
			set_drag_preview(preview.duplicate())
			preview.set_visible(false)
			return { id = "foobar", card = select_node }

func can_drop_data(position: Vector2, data) -> bool:
	return true

func drop_data(position: Vector2, data) -> void:
#	if is_hovered():
#		if guit == GUIT.HAND:
#		if guit == GUIT.TABEL:
	clear_action()
	$ArrowLine.hide()
	var card = gui_client.l_tabel_cards[select_card_id].duplicate()
	var tween = get_node("Tween")
	tween.interpolate_method(card, "set_position",
			Vector2(0, 0), position, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func set_layout(screen_size: Vector2):
	self.screen_size = screen_size
	screen_center = screen_size * 0.5 
	card_size = Vector2(200, 200) 
	card_indent = Vector2(10, 0) 
	gui_setting = $Setting.get_rect()
	gui_end = $End.get_rect()
	gui_client.pid = PID.CLIENT
	gui_client.deck = $Client/Deck.get_rect()
	gui_client.build = $Client/Build.get_rect()
	gui_client.avatar = $Client/Avatar.get_rect()
	gui_client.l_tabel = Rect2(0, screen_size.y * 0.5, screen_size.x * 0.5, screen_size.y * 0.25)
	gui_client.r_tabel = Rect2(screen_size.x * 0.5, screen_size.y * 0.5, screen_size.x * 0.5, screen_size.y * 0.25)
	gui_client.hand = Rect2(0, screen_size.y - card_size.y, screen_size.x, screen_size.y * 0.25)
	gui_opp.pid = PID.OPP
#	gui_opp.deck = $Client/Deck.get_rect()
#	gui_opp.build = $Setting.get_rect()
#	gui_opp.avatar = $Setting.get_rect()
#	gui_opp.l_tabel = Rect2(0, screen_size.y * 0.5, screen_size.x * 0.5, screen_size.y * 0.25)
#	gui_opp.r_tabel = Rect2(screen_size.x * 0.5, screen_size.y * 0.5, screen_size.x * 0.5, screen_size.y * 0.25)
#	gui_opp.hand = Rect2(0, screen_size.y - screen_size.y * 0.5, screen_size.x, screen_size.y * 0.25)

#end_idx
func line_aligment(anchor: Vector2, cards: Array, aligment: int = 0, witch_blink: bool = false, start_idx: int = 0):
	var count = cards.size()
	var offset := card_size.x + card_indent.x
	var start_x := 0
	match aligment:
		Aligment.CENTER:
			start_x = (count * offset - card_indent.x) * -1
		Aligment.START:
			start_x = offset
		Aligment.END:
			offset *= -1
			start_x = offset
	var x := screen_center.x + start_x * 0.5
	
	if witch_blink:
		x += offset
		
	for i in range(start_idx, count):
		cards[i].set_position(Vector2(x, anchor.y))
		x += offset

func line_card_has_point(mouse_pos: Vector2, anchor: Vector2, count: int, aligment: int = 0 ):
	var offset := card_size.x + card_indent.x
	var start_x := 0
	match aligment:
		Aligment.CENTER:
			start_x = (count * offset - card_indent.x) * -1
		Aligment.START:
			start_x = offset
		Aligment.END:
			offset *= -1
			start_x = offset
	var x := screen_center.x + start_x * 0.5

	for card_id in range(count):
		if rect_has_point(x, anchor.y, card_size, mouse_pos):
			set_select_card(card_id)
			return
		else:
			x += offset
	
	set_unselect_card()

#hand shifting and swap pos
func line_indent_has_point(mouse_pos: Vector2, anchor: Vector2, count: int, aligment: int = 1 ):
	var offset := card_size.x + card_indent.x
	var start_x := card_indent.x
	match aligment:
#		Aligment.CENTER:
#			start_x = (count * offset - card_indent.x) * -1
#		Aligment.START:
#			start_x = card_indent.x
		Aligment.END:
			offset *= -1
			start_x *= -1
	var x := screen_center.x + start_x * 0.5

	for card_id in range(count):
		if rect_has_point(x, anchor.y, card_size + card_indent, mouse_pos):
			set_taget_card(card_id)
			return
		else:
			x += offset
	
	set_untarget_card()

#func line_aligment_from(mouse_pos: Vector2, anchor: Vector2, cards: Array, aligment: int = 0 ):
#	var count = cards.size()
#	var offset := card_size.x + card_indent.x
#	var start_x := 0
#	match aligment:
#		Aligment.CENTER:
#			start_x = (count * offset - card_indent.x) * -1
#		Aligment.START:
#			start_x = offset
#		Aligment.END:
#			offset *= -1
#			start_x = offset
#	var x := screen_center.x + start_x * 0.5
#
#	var find := false
#	for card in cards:
#		find = rect_has_point(x, anchor.y, card_size, mouse_pos)
#		if find:
#			x += offset
#			card.set_position(Vector2(x, anchor.y))
#		else:
#			x += offset 
	
static func rect_has_point(x: float, y: float, size: Vector2, p: Vector2):
		if p.x < x:
			return false
		if p.y < y:
			return false
		if p.x >= (x + size.x):
			return false
		if p.y >= (y + size.y):
			return false
		return true

#func _on_matchmaker_matched(p_matched : NakamaRTAPI.MatchmakerMatched):
#	#if accept
#	client.join_to_match(p_matched)
