extends Component
class_name Tabel

var texture: Texture = load("res://assets/error.png") as Texture
var left_list: List = List.new()
var right_list: List = List.new()
var avatar_list: List = List.new()

func draw(ctx: Context) -> void:
#	if texture:
#		ctx.draw_texture_rect(texture, box.rect(), false)
	for i in range(avatar_list.lenght() - 1, -1, -1):
		var card: Card = avatar_list.get_card(i)
		card.draw_on_line(ctx, avatar_list.card_size())
	for i in range(right_list.lenght() - 1, -1, -1):
		var card: Card = right_list.get_card(i)
		card.draw_on_line(ctx, right_list.card_size())
	for i in range(left_list.lenght() - 1, -1, -1):
		var card: Card = left_list.get_card(i)
		card.draw_on_line(ctx, left_list.card_size())
#	if box.is_hovered():
#		var card: Card = get_focused_card()
#		if card:
#			var box: Box = Box.new()
#			box.set_rect(Rect2(card.position(), Vector2(200, 200)))
#			box.set_hovered(true)
#			ctx.draw_hovered(box)

#	if list.get_focused_card_id() > -1:
#		var card: Card = list.get_focused_card()
#		var box: Box = Box.new()
#		box.set_rect(Rect2(card.position(), list.card_size()))
#		box.set_hovered(true)
#		ctx.draw_hovered(box)

#func draw_hovered(ctx: CanvasItem) -> void:
#func draw_avatar_list(ctx: CanvasItem) -> void:

func add_card_to_focus(card: Card) -> void:
	if left_list.has_focused_card():
		left_list.add_card(card, get_focused_card_id())
	elif right_list.has_focused_card():
		right_list.add_card(card, get_focused_card_id())

func casting(point: Vector2) -> void:
	if left_list.has_focused_card():
		left_list.casting(point)
	elif right_list.has_focused_card():
		right_list.casting(point)

func focused_card(point: Vector2) -> void:
	if avatar_list.focused_card(point):
		pass
	elif left_list.focused_card(point):
		pass
	elif right_list.focused_card(point):
		pass

func get_focused_card() -> Card:
	if avatar_list.has_focused_card():
		return avatar_list.get_focused_card()
	elif left_list.has_focused_card():
		return left_list.get_focused_card()
	elif right_list.has_focused_card():
		return right_list.get_focused_card()
	return null

func get_focused_card_id() -> int:
	if avatar_list.has_focused_card():
		return avatar_list.get_focused_card_id()
	elif left_list.has_focused_card():
		return left_list.get_focused_card_id()
	elif right_list.has_focused_card():
		return right_list.get_focused_card_id()
	return -1

func has_focused_card() -> bool:
	return avatar_list.has_focused_card() or \
		left_list.has_focused_card() or \
		right_list.has_focused_card()

func unfocused_card() -> void:
	if avatar_list.has_focused_card():
		avatar_list.aligment_line()
		avatar_list.unfocused_card()
	if left_list.has_focused_card():
		left_list.aligment_line()
		left_list.unfocused_card()
	if right_list.has_focused_card():
		right_list.aligment_line()
		right_list.unfocused_card()

func cached_card(card_id: int) -> void:
	if avatar_list.has_focused_card():
		avatar_list.cached_card(card_id)
	if left_list.has_focused_card():
		left_list.cached_card(card_id)
	if right_list.has_focused_card():
		right_list.cached_card(card_id)

func get_cached_card() -> Card:
	if avatar_list.has_focused_card():
		return avatar_list.get_cached_card()
	elif left_list.has_focused_card():
		return left_list.get_cached_card()
	elif right_list.has_focused_card():
		return right_list.get_cached_card()
	return null

func uncached_card() -> void:
	if avatar_list.has_focused_card():
		avatar_list.uncached_card()
	if left_list.has_focused_card():
		left_list.uncached_card()
	if right_list.has_focused_card():
		right_list.uncached_card()

func remove_cached_card() -> Card:
	if avatar_list.has_focused_card():
		return avatar_list.remove_cached_card()
	elif left_list.has_focused_card():
		return left_list.remove_cached_card()
	elif right_list.has_focused_card():
		return right_list.remove_cached_card()
	return null




#func input(sense: Sense) -> void:
#	pass
#	if box.is_dragging():
#		_focused_card_id = has_point_on_cast(sense.mouse_pos())
#		casting_on(_focused_card_id)
#	elif box.is_targeting():
#		pass
#	else:
#		_focused_card_id = has_point_on_card(sense.mouse_pos())
		
#		box.set_hovered(true)
#	if box.is_clicked():
#		var is_right := tabel.has_right_side(mouse_pos)
#		#if casting change type check card position evaible
#		#if card_id >= avatar_id = is_right
#	if sense.clicked():
#		sense.input_event(MouseEnter, Tabel, player_id, card_id, can_drag)
#func has_right_side(point: Vector2) -> bool:
#	return point.x > _rect.size.x * 0.5

#func dragging(sense: Sense):
#	#	if targgeting() and player_id != this_player_id():
##	if casting() and player_id == this_player_id() and card_id > -1:
##	tabel.casting_on(card_id, is_right)
#	if sense.drag_view_id() == Sense.Hand:
#		var card_id := has_point_on_cast(sense.mouse_pos())
#		sense.set_card_id(card_id)
#		casting_on(card_id)
##	if sense.drag_view_id() == Sense.Tabel:


#func draw(ctx: CanvasItem) -> void:
##	if texture:
##		ctx.draw_texture_rect(texture, box.rect(), false)
#	for i in range(list.size() - 1, -1, -1):
#		var card: Card = list.get_card(i)
#		card.draw_on_line(ctx, list.card_size())
#	#todo
##	if _focused_card_id > -1:
##		if box.is_dragging():
##			pass
##		elif box.is_targeting():
##			if _miroring:
##				pass
##			else:
##				pass
##		else:
##			pass
##	if _cached_card_id > -1:
##		pass
#	if list.get_focused_card_id() > -1:
#		var card: Card = list.get_focused_card()
#		var box: Box = Box.new()
#		box.set_rect(Rect2(card.position(), list.card_size()))
#		box.set_hovered(true)
#		ctx.draw_hovered(box)
