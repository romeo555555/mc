extends Component
class_name Hand

var list: List
var texture: Texture
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false

func _init(
	miroring: bool,
	ctx: Context,
	parent: Component,
	relative_type: int
#	offset: Vector2 = Vector2.ZERO,
#	custom_size: Vector2 = Vector2.ZERO
).(
	ctx,
	parent,
	relative_type
#	offset,
#	custom_size
) -> void:
	texture = load("res://assets/error.png") as Texture
	list = List.new(ctx, self, Component.Padding, Vector2(0, 20))
	list.set_item_size(1, -50.0)
	list.set_capacity(10)
	list.set_aligment_type(List.Aligment.Bent)
	list.set_miroring(miroring)

func render(ctx: Context) -> void:
	input(ctx)
#	if texture:
#		ctx.draw_texture_rect(texture, box.rect(), false)
#	for i in range(list.lenght() - 1, -1, -1):
	for i in range(0, list.lenght()):
		var card: Card = list.get_item(i)
		card.render(ctx)
	#todo
#	if list.get_focused_card_id() > -1:
#		var card: Card = list.get_focused_card()
#		var box: Box = Box.new()
#		box.set_rect(Rect2(card.position(), list.card_size()))
#		box.set_hovered(true)
#		ctx.draw_hovered(box)

func draw_cached_card(ctx: Context, position: Vector2) -> void:
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
	

#var _cached_card_id: int
#var _cached_card_pos: Vector2
#var _cached_card_rot: float
#
#func cached_card(card_id: int) -> void:
#	var card: Card = _list[card_id]
#	_cached_card_id = card_id
#	_cached_card_pos = card.position()
#	_cached_card_rot = card.rotation()
##	card.set_visible(false)
##	card.set_rotation(0)
##	card.set_scale(Vector2.ONE)
#
#func get_cached_card() -> Card:
#	return get_card(_cached_card_id)
#
#func uncached_card() -> void:
#	var card: Card = _list[_cached_card_id]
#	card.set_visible(true)
#	card.set_position(_cached_card_pos)
#	card.set_rotation(_cached_card_rot)
#	card.set_scale(Vector2.ONE)
#
#func remove_cached_card() -> Card:
#	return remove_card(_cached_card_id)
