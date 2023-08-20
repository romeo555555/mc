extends Control

const proto: Reference = preload("res://proto/buff.gd")
const layout: Reference = preload("res://src/Layout.gd")
const network: Reference = preload("res://src/Network.gd")
const fab_hand_card: PackedScene = preload("res://scn/HandCard.tscn")
const fab_tabel_card: PackedScene = preload("res://scn/TabelCard.tscn")
const fab_build: PackedScene = preload("res://scn/Build.tscn")
const fab_deck: PackedScene = preload("res://scn/Deck.tscn")

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
var sense := layout.Sense.new()
#TODO

func _ready():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)

	#init start state
	for i in range(3):
		var card = fab_hand_card.instance()
		add_child(card)
		var id = card.get_instance_id()
		state.client.hand[id] = card
		
		var tcard = fab_tabel_card.instance()
		add_child(tcard)
		var tid = tcard.get_instance_id()
		state.client.tabel[tid] = tcard
		
		var otcard = fab_tabel_card.instance()
		add_child(otcard)
		var otid = otcard.get_instance_id()
		state.opp.tabel[tid] = otcard
	
	layout.aligment(state, layout.CLIENT, layout.HAND)
	layout.aligment(state, layout.CLIENT, layout.TABEL)
	layout.aligment(state, layout.OPP, layout.TABEL)
	sense = layout.Sense.new()
	
	var cbuild = fab_build.instance()
	add_child(cbuild)
	state.client.build = cbuild
	var obuild = fab_build.instance()
	add_child(obuild)
	state.opp.build = obuild
	var cdeck = fab_deck.instance()
	add_child(cdeck)
	state.client.deck = cdeck
	var odeck = fab_deck.instance()
	add_child(odeck)
	state.opp.deck = odeck
	
	layout.aligment(state, layout.CLIENT, layout.DECK)
	layout.aligment(state, layout.CLIENT, layout.BUILD)
	layout.aligment(state, layout.OPP, layout.DECK)
	layout.aligment(state, layout.OPP, layout.BUILD)

func _input(event: InputEvent):
#	reset_hovered()
	if event is InputEventMouseMotion:
		sense.mouse_pos = event.position
	if sense.dragging:
#		layout.dragging()
		$ArrowLine.set_point_position(1, sense.mouse_pos)

	layout.containe(sense, state)
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

func get_drag_data(position: Vector2):
	if sense.hovered:
		if sense.guit == layout.HAND:
			var preview = sense.hovered.duplicate()
			set_drag_preview(preview)
			return { id = "foobar", card = sense.hovered }
		if sense.guit == layout.TABEL:
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
