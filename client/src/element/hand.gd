extends Object
class_name Hand

var box: Box = Box.new()
var list: List = List.new()
var texture: Texture = load("res://assets/error.png") as Texture
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false

func draw(ctx: CanvasItem) -> void:
#	if texture:
#		ctx.draw_texture_rect(texture, box.rect(), false)
	for i in range(list.size() - 1, -1, -1):
		var card: Card = list.get_card(i)
		card.draw(ctx, list.card_size())
	#todo
	if list.get_focused_card_id() > -1:
		var card: Card = list.get_focused_card()
		var box: Box = Box.new()
		box.set_rect(Rect2(card.position(), list.card_size()))
		box.set_hovered(true)
		ctx.draw_hovered(box)

func draw_cached_card(ctx: CanvasItem, position: Vector2) -> void:
	var card: Card = list.get_cached_card()
	card.set_visible(true)
	card.set_position(position - list.card_size() * 0.5)
	card.draw(ctx, list.card_size())
	card.set_visible(false)

#func highlight_reset() -> void:
#	for card in _cards:
#		card.set_highlight(false)
#
#func hover_on(card_id: int) -> void:
#	_cards[card_id].set_highlight(true, Color.aqua)
#
#func hover_off(card_id: int) -> void:
#	_cards[card_id].set_highlight(false)

func add_card(card: Card, idx: int = -1) -> void:
	list.add_card(card, idx)

func focused_card(point: Vector2) -> void:
	list.focused_card(point)

func get_focused_card() -> Card:
	if list.has_focused_card():
		return list.get_focused_card()
	return null

func get_focused_card_id() -> int:
	return list.get_focused_card_id()

func has_focused_card() -> bool:
	return list.has_focused_card()

func unfocused_card() -> void:
	if list.has_focused_card():
		list.aligment_line()
		list.unfocused_card()

func cached_card(card_id: int) -> void:
	list.cached_card(card_id)

func get_cached_card() -> Card:
	return list.get_cached_card()

func uncached_card() -> void:
	list.uncached_card()

func remove_cached_card() -> Card:
	return list.remove_cached_card()
