extends Reference
class_name Layout

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

enum { NONE, HAND, TABEL, DECK, BUILD, SETTING, END }
class Sense:
	var mouse_pos := Vector2(0.0, 0.0)
	var player_id := 0
	var guit := 0
	var dragging := false
	var hovered = null

#func draw():
#	if sense.hovered:
#		print("draw hov")
#		draw_rect(sense.hovered.get_rect(), Color.red, false, 30.0, false)
			
static func aligment(state: Dictionary, player_id: int, guit: int):
	if guit == DECK:
		if player_id == CLIENT:
			state.client.deck.set_position(client_deck_pos)
		if player_id == OPP:
			state.opp.deck.set_position(opp_deck_pos)
		return
	if guit == BUILD:
		if player_id == CLIENT:
			state.client.build.set_position(opp_build_pos)
		if player_id == OPP:
			state.opp.build.set_position(opp_build_pos)
		return
	
	var cards := {}
	var anchor := Vector2.ZERO
	if guit == HAND:
		if player_id == CLIENT:
			cards = state.client.hand
			anchor = client_hand_pos
		if player_id == OPP:
			cards = state.opp.hand
			anchor = opp_hand_pos
	if guit == TABEL:
		if player_id == CLIENT:
			cards = state.client.tabel
			anchor = client_tabel_pos
		if player_id == OPP:
			cards = state.opp.tabel
			anchor = opp_tabel_pos
	
	var count = cards.size()
	var w = count * card_size.x + (count - 1) * card_indent.x
	var x = (screen_size.x - w) * 0.5
	#print(x)
	for card in cards.values():
		card.set_position(Vector2(x, anchor.y))
		x += card_size.x + card_indent.x

static func containe(sense: Sense, state: Dictionary):
	var mouse_pos = sense.mouse_pos
	if rect_has_point(setting_pos.x, setting_pos.y, setting_size, mouse_pos):
		sense.guit = SETTING
	elif rect_has_point(end_pos.x, end_pos.y, end_size, mouse_pos):
		sense.guit = END
	else:
		if mouse_pos.y > screen_center.y:
			sense.player_id = CLIENT
			if rect_has_point(client_deck_pos.x, client_deck_pos.y, deck_size, mouse_pos):
				sense.guit = DECK
				return
			if rect_has_point(client_build_pos.x, client_build_pos.y, build_size, mouse_pos):
				sense.guit = BUILD
				return
			if mouse_pos.y > client_hand_pos.y:
				sense.guit = HAND
			else:
				sense.guit = TABEL
		else:
			sense.player_id = OPP
			if rect_has_point(opp_deck_pos.x, opp_deck_pos.y, deck_size, mouse_pos):
				sense.guit = DECK
				return
			if rect_has_point(opp_build_pos.x, opp_build_pos.y, build_size, mouse_pos):
				sense.guit = BUILD
				return
			if mouse_pos.y > opp_hand_pos.y:
				sense.guit = HAND
			else:
				sense.guit = TABEL
	
	var cards := {}
	var anchor := Vector2.ZERO
	if sense.guit == HAND:
		if sense.player_id == CLIENT:
			cards = state.client.hand
			anchor = client_hand_pos
		if sense.player_id == OPP:
			cards = state.opp.hand
			anchor = opp_hand_pos
	if sense.guit == TABEL:
		if sense.player_id == CLIENT:
			cards = state.client.tabel
			anchor = client_tabel_pos
		if sense.player_id == OPP:
			cards = state.opp.tabel
			anchor = opp_tabel_pos
	
	var count = cards.size()
	var w = count * card_size.x + (count - 1) * card_indent.x
	var x = (screen_size.x - w) * 0.5
	
	for card in cards.values():
		if rect_has_point(x, anchor.y, card_size, sense.mouse_pos):
			print("hovered")
			sense.hovered = card
#			update() 
			return
		else:
			x += card_size.x + card_indent.x

#static func dragginig():
#	$ArrowLine.set_point_position(1, sense.mouse_pos)

#func get_drag_data(position: Vector2):
#	if sense.hovered:
#		if sense.guit == GUIT.HAND:
#			var preview = sense.hovered.duplicate()
#			set_drag_preview(preview)
#			return { id = "foobar", card = sense.hovered }
#		if sense.guit == GUIT.TABEL:
#			sense.dragging = true
#			$ArrowLine.show()
#			$ArrowLine.set_point_position(0, position)
#			$ArrowLine.set_point_position(1, position)
#			var preview = $Arrow
#			preview.set_visible(true)
#			set_drag_preview(preview.duplicate())
#			preview.set_visible(false)
#			return { id = "foobar", card = sense.hovered }
#
#func can_drop_data(position: Vector2, data) -> bool:
#	print('can drop data')
#	return true
#
#func drop_data(position: Vector2, data) -> void:
#	print('accepting drop data')
#	sense.dragging = false
#	$ArrowLine.hide()
#	var tween = get_node("Tween")
#	tween.interpolate_method(data.card, "set_position",
#			Vector2(0, 0), position, 1,
#			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
#	pass

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
