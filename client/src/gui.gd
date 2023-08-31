extends Reference
class_name GuiPlayer

const slt: Reference = preload("res://src/select.gd")

var pid: int
var deck: Rect2
var build: Rect2
var avatar: Rect2
var ltabel: Rect2
var ltab_aligment: int
var ltabel_cards: Array
var rtabel: Rect2
var rtab_aligment: int
var rtabel_cards: Array
var hand: Rect2
var hand_aligment: int
var hand_cards: Array

func set_layout():
	pass

func input_player(select: Select, pid: int):
	var mouse_pos := select.mouse_pos
	select.pid = pid
	if deck.has_point(mouse_pos):
		select.guit = slt.DECK
		return
	elif build.has_point(mouse_pos):
		select.guit = slt.BUILD
		return
	elif avatar.has_point(mouse_pos):
		select.guit = slt.AVATAR
		return
	elif ltabel.has_point(mouse_pos):
#		if is_dragging() || is_targeting():
#			select.line_indent_has_point(anchor, count, aligment)
#		else:
		select.line_card_has_point(slt.L_TABEL, ltabel.position, ltabel_cards.size(), ltab_aligment)
		return
	elif rtabel.has_point(mouse_pos):
		select.tabel_card_has_point(rtabel.position, rtabel_cards.size(), rtab_aligment)
		return
	else:
		select.guit = slt.HAND
#		if is_dragging():
#		else:
		line_card_has_point(mouse_pos, hand.position, hand_cards.size())
#		if select_node:
#			drag = false
#			dragging = true
#			set_drag_preview(select_node.duplicate())
#			force_drag({id = "ff"}, select_node.duplicate())
		return
#func rtabel_aligment(anchor: Vector2, cards: Array, aligment: int = 0, witch_blink: bool = false, start_idx: int = 0):
#func ltabel_aligment(anchor: Vector2, cards: Array, aligment: int = 0, witch_blink: bool = false, start_idx: int = 0):
#func hand_aligment(anchor: Vector2, cards: Array, aligment: int = 0, witch_blink: bool = false, start_idx: int = 0):
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
#	if witch_blink:
#		x += offset
#
#	for i in range(start_idx, count):
#		cards[i].set_position(Vector2(x, anchor.y))
#		x += offset
