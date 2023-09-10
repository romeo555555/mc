extends Reference

var _clicked := false
var _hovered := false
var _dragging := false
var _cached_prev_card_id: int
var _cached_rect: Rect2
var _cached_card_id: int

func set_select_card(idx: int, rect: Rect2):
	_cached_prev_card_id = _cached_card_id
	_cached_card_id = idx
	_cached_rect = rect

#func select_card() -> Node:
#	return get_child(_cached_card_id)
	
func set_hovered():
	if _hovered:
		get_child(_cached_prev_card_id).get_child(0).set_visible(false)
	select_card().get_child(0).set_visible(true)
	_hovered = true

func check_hovered(mouse_pos: Vector2):
	if _hovered and not _cached_rect.has_point(mouse_pos):
		hovered_off()

func hovered_off():
	select_card().get_child(0).set_visible(false)
	_hovered = false

#func is_hovered() -> bool:
#	return action == Action.HOVER
#
#func is_dragging() -> bool:
#	return action == Action.DRAGGING
#
#func is_clicked() -> bool:
#	return action == Action.CLICK
#
#func is_card_select() -> bool:
#	return card_selected
#
#func is_card_target() -> bool:
#	return card_target
#
#func set_taget_card(card_id: int):
#	card_target = true
#	target_card_id = card_id
#
#func set_untarget_card():
#	card_target = false
#
#func set_select_card(card_id: int):
#	card_selected = true
#	select_card_id = card_id
#
#func set_unselect_card():
#	card_selected = false
#
#func set_hovered(rect: Rect2, node: Control):
#	cached_hovered_rect = rect
#	node.get_child(0).set_visible(true)
#	select_node = node
#	action = Action.HOVER
#
#func set_dragging():
#	action = Action.DRAGGING
#
#func set_clicked():
#	action = Action.CLICK
#
#func clear_action():
#	action = Action.NONE
#
#func check_hovered(mouse_pos: Vector2):
#	if action == Action.HOVER:
#		if cached_hovered_rect.has_point(mouse_pos):
#			print("hovered")
#		else:
#			action = Action.NONE
#			select_node.get_child(0).set_visible(false)
#			select_node = null
