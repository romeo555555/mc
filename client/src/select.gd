extends Reference
class_name Select

#const NONE: int = 0
enum { NONE, HAND, HAND_CARD, R_TABEL, R_TABEL_CARD, L_TABEL, L_TABEL_CARD, DECK, AVATAR, BUILD, SETTING, END }
enum Action { NONE, CLICK, HOVER, DRAG, DRAGGING, TARGETING, DROP }
enum Aligment { NONE, CENTER, START, END }
enum PID { NONE, CLIENT, FRIEND, OPP, OPP_FRIEND }

#var screen_center := screen_size * 0.5 
var screen_size := Vector2(1980, 1080) 
var card_size := Vector2(200, 200) 
var card_indent := Vector2(10, 0) 
var mouse_pos := Vector2.ZERO
var guit_card_id: = 0 
var guit: int = NONE
var pid: int = NONE
var action: int = NONE
var target_card_id: = 0
var cached_hovered_rect: Rect2
#var select_node = null #need only for hovered_vible_on

func is_clicked() -> bool:
	return action == Action.CLICK

func is_hovered() -> bool:
	return action == Action.HOVER

func is_dragging() -> bool:
	return action == Action.DRAGGING

func is_targeting() -> bool:
	return action == Action.TARGETING

func set_clicked():
	action = Action.CLICK

func set_hovered(rect: Rect2, node: Control):
	cached_hovered_rect = rect
	node.get_child(0).set_visible(true)
#	select_node = node
	action = Action.HOVER

func set_dragging():
	action = Action.DRAGGING

func set_targeting(card_id: int):
	target_card_id = card_id
	action = Action.TARGETING

func clear_action():
	action = Action.NONE

func set_client():
	pid = PID.CLIENT


func line_card_has_point(in_guit: int, anchor: Vector2, count: int, aligment: int):
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
	var x := (screen_size.x + start_x) * 0.5

	for card_id in range(count):
		if rect_has_point(x, anchor.y, card_size, mouse_pos):
			guit = in_guit + 1
			guit_card_id = card_id
			return
		else:
			x += offset
	guit = in_guit

#hand shifting and swap pos
func line_indent_has_point(in_guit: int, anchor: Vector2, count: int, aligment: int):
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
	var x := (screen_size.x + start_x) * 0.5

	for card_id in range(count):
		if rect_has_point(x, anchor.y, card_size + card_indent, mouse_pos):
			set_targeting(card_id)
			return
		else:
			x += offset
	
#	set_untarget_card()

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
