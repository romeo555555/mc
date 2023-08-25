#class_name Board
extends Control

const fab_hand_card = preload("res://prefab/HandCard.tscn")
const fab_tabel_card = preload("res://prefab/TabelCard.tscn")
const fab_build = preload("res://prefab/Build.tscn")
const fab_deck = preload("res://prefab/Deck.tscn")


const screen_size := Vector2(1980, 1080)
const screen_center = screen_size * 0.5
const card_size := Vector2(200, 200) 
const card_indent := Vector2(10, 0) 
const deck_size := card_size
const deck_offset := Vector2(20, 20) 
const build_size := card_size
const build_offset := Vector2(20, 20) 
const opp_deck_pos := Vector2(0.0 + deck_offset.x, 0.0 + deck_offset.y)
const opp_build_pos := Vector2(screen_size.x - (build_size.x + build_offset.x), 0.0 + build_offset.y)
const opp_hand_pos := Vector2(0.0, card_size.y)
const opp_tabel_pos := Vector2(0.0, card_size.y * 2)
const client_deck_pos := screen_size - (deck_size + deck_offset)
const client_build_pos := Vector2(0.0 + deck_offset.x, screen_size.y - (deck_size.y + deck_offset.y))
const client_hand_pos := Vector2(0.0, screen_size.y - card_size.y)
const client_tabel_pos := Vector2(0.0, screen_size.y - card_size.y * 2)
const setting_pos := Vector2(0.0, 0.0)
const setting_size := Vector2(0.0, 0.0)
const end_pos := Vector2(0.0, 0.0)
const end_size := Vector2(0.0, 0.0)

const CLIENT = 1
const OPP = 2

enum GUIT { NONE, HAND, TABEL, DECK, BUILD, SETTING, END }
class Sense:
	var mouse_pos := Vector2(0.0, 0.0)
	var player_id := 0
	var guit := 0
	var dragging := false
	var hovered = null


var sense := Sense.new()
const state = {
	"client": {
		"tabel": {},
		"hand": {},
	},
	"opp": {
		"tabel": {},
		"hand": {},
	},
}
var client : NakamaClient
#TODO

func _ready():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
	
	var data = {
	  "Key": "Value",
	  "AnotherKey": "AnotherValue"
	}
	var serialized = JSON.print(data)
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	client.timeout = 10
	var device_id = OS.get_unique_id()
	var session : NakamaSession = yield(client.authenticate_device_async(device_id), "completed")
	if session.is_exception():
		print("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
	
#	onready 
	var socket := Nakama.create_socket_from(client)
	var connected : NakamaAsyncResult = yield(socket.connect_async(session), "completed")
	if connected.is_exception():
		print("An error occurred: %s" % connected)
		return
	print("Socket connected.")


	#init start state
	for i in range(3):
		var card = fab_hand_card.instance()
		add_child(card)
#		card.set_visible(true)
		#inst_id change to server card id
		var id = card.get_instance_id()
		state.client.hand[id] = card
		
		var tcard = fab_tabel_card.instance()
		add_child(tcard)
#		tcard.set_visible(true)
		#inst_id change to server card id
		var tid = tcard.get_instance_id()
		state.client.tabel[tid] = tcard
		
		var otcard = fab_tabel_card.instance()
		add_child(otcard)
#		otcard.set_visible(true)
		#inst_id change to server card id
		var otid = otcard.get_instance_id()
		state.opp.tabel[tid] = otcard
	
#	var tween = get_tree().create_tween()
#	tween.tween_property($TabelCard, "modulate", Color.red, 1)
	aligment(state, CLIENT, GUIT.HAND)
	aligment(state, CLIENT, GUIT.TABEL)
	aligment(state, OPP, GUIT.TABEL)
	sense = Sense.new()
	
	var cbuild = fab_build.instance()
	cbuild.set_position(client_build_pos)
	add_child(cbuild)
	var obuild = fab_build.instance()
	obuild.set_position(opp_build_pos)
	add_child(obuild)
	var cdeck = fab_deck.instance()
	cdeck.set_position(client_deck_pos)
	add_child(cdeck)
	var odeck = fab_deck.instance()
	odeck.set_position(opp_deck_pos)
	add_child(odeck)
	
func _input(event: InputEvent):
#	reset_hovered()
	if event is InputEventMouseMotion:
		var mouse_pos = event.position
#		print("Mouse Motion at: ", event.position)
		if rect_has_point(setting_pos.x, setting_pos.y, setting_size, mouse_pos):
			sense.guit = GUIT.SETTING
		elif rect_has_point(end_pos.x, end_pos.y, end_size, mouse_pos):
			sense.guit = GUIT.END
		else:
			if mouse_pos.y > screen_center.y:
				sense.player_id = CLIENT
				sense.guit = (
					GUIT.DECK if rect_has_point(client_deck_pos.x, client_deck_pos.y, deck_size, mouse_pos)
					else GUIT.BUILD if rect_has_point(client_build_pos.x, client_build_pos.y, build_size, mouse_pos)
					else GUIT.HAND if mouse_pos.y > client_hand_pos.y
					else GUIT.TABEL
				)
			else:
				sense.player_id = OPP
				sense.guit = (
					GUIT.DECK if rect_has_point(opp_deck_pos.x, opp_deck_pos.y, deck_size, mouse_pos)
					else GUIT.BUILD if rect_has_point(opp_build_pos.x, opp_build_pos.y, build_size, mouse_pos)
					else GUIT.HAND if mouse_pos.y > opp_hand_pos.y
					else GUIT.TABEL
				)
		
		sense.mouse_pos = mouse_pos
	if sense.dragging:
		$ArrowLine.set_point_position(1, sense.mouse_pos)
	
	containe(state, sense.player_id, sense.guit)
#	print(sense.guit)
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if sense.hovered:
				print("Left button was clicked at ", event.position)
		

func _process(delta: float):
	pass

func _draw():
	if sense.hovered:
		print("draw hov")
		draw_rect(sense.hovered.get_rect(), Color.red, false, 30.0, false)
			
func aligment(state: Dictionary, player_id: int, guit: int):
	var cards := {}
	var anchor := Vector2.ZERO
	if player_id == CLIENT:
			if guit == GUIT.HAND:
				cards = state.client.hand
				anchor = client_hand_pos
			if guit == GUIT.TABEL:
				cards = state.client.tabel
				anchor = client_tabel_pos
	elif player_id == OPP:
			if guit == GUIT.HAND:
				cards = state.opp.hand
				anchor = opp_hand_pos
			if guit == GUIT.TABEL:
				cards = state.opp.tabel
				anchor = opp_tabel_pos
	else:
		return
	
	var count = cards.size()
	var w = count * card_size.x + (count - 1) * card_indent.x
	var x = (screen_size.x - w) * 0.5
	
	print(x)
	for card in cards.values():
		card.set_position(Vector2(x, anchor.y))
		x += card_size.x + card_indent.x

func containe(state: Dictionary, player_id: int, guit: int):
	var cards := {}
	var anchor := Vector2.ZERO
	if player_id == CLIENT:
			if guit == GUIT.HAND:
				cards = state.client.hand
				anchor = client_hand_pos
			if guit == GUIT.TABEL:
				cards = state.client.tabel
				anchor = client_tabel_pos
	elif player_id == OPP:
			if guit == GUIT.HAND:
				cards = state.opp.hand
				anchor = opp_hand_pos
			if guit == GUIT.TABEL:
				cards = state.opp.tabel
				anchor = opp_tabel_pos
	else:
		return

	var count = cards.size()
	var w = count * card_size.x + (count - 1) * card_indent.x
	var x = (screen_size.x - w) * 0.5

	for card in cards.values():
		if rect_has_point(x, anchor.y, card_size, sense.mouse_pos):
			print("hovered")
			sense.hovered = card
			update() 
			return
		else:
			x += card_size.x + card_indent.x

func get_drag_data(position: Vector2):
	if sense.hovered:
		if sense.guit == GUIT.HAND:
			var preview = sense.hovered.duplicate()
			set_drag_preview(preview)
			return { id = "foobar", card = sense.hovered }
		if sense.guit == GUIT.TABEL:
			sense.dragging = true
			$ArrowLine.show()
			$ArrowLine.set_point_position(0, position)
			$ArrowLine.set_point_position(1, position)
			var preview = $Arrow
			preview.set_visible(true)
			set_drag_preview(preview.duplicate())
			preview.set_visible(false)
			return { id = "foobar", card = sense.hovered }

func can_drop_data(position: Vector2, data) -> bool:
	print('can drop data')
	return true

func drop_data(position: Vector2, data) -> void:
	print('accepting drop data')
	sense.dragging = false
	$ArrowLine.hide()
	var tween = get_node("Tween")
	tween.interpolate_method(data.card, "set_position",
			Vector2(0, 0), position, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	pass

func rect_has_point(x: float, y: float, size: Vector2, p: Vector2):
		if p.x < x:
			return false
		if p.y < y:
			return false
		if p.x >= (x + size.x):
			return false
		if p.y >= (y + size.y):
			return false
		return true
