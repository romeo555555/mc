#tool
extends Node2D#TextureButton
class_name Card
onready var parent: Node = get_parent()

func _ready():
	set_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_physics_process(false)
	set_physics_process_internal(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func get_drag_data(position: Vector2):
##	if is_card_select():
##		if guit == GUIT.HAND:
##			set_dragging()
##			var preview = gui_client.l_tabel_cards[select_card_id].duplicate()
#			var preview = self.duplicate()
#			set_drag_preview(preview)
#			return { id = "foobar" } #, card = select_node
##		if guit == GUIT.L_TABEL || guit == GUIT.R_TABEL:
##			set_dragging()
##			$ArrowLine.show()
##			$ArrowLine.set_point_position(0, position)
##			$ArrowLine.set_point_position(1, position)
##			var preview = $Arrow
##			preview.set_visible(true)
##			set_drag_preview(preview.duplicate())
##			preview.set_visible(false)
##			return { id = "foobar", card = select_node }
##
##func can_drop_data(position: Vector2, data) -> bool:
##	return true
##
##func drop_data(position: Vector2, data) -> void:
###	if is_hovered():
###		if guit == GUIT.HAND:
###		if guit == GUIT.TABEL:
##	clear_action()
##	$ArrowLine.hide()
##	var card = gui_client.l_tabel_cards[select_card_id].duplicate()
##	var tween = get_node("Tween")
##	tween.interpolate_method(card, "set_position",
##			Vector2(0, 0), position, 1,
##			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
##	tween.start()
##
