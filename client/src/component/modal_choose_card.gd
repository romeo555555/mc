extends Component
class_name ModalChooseCard

var list: List
var texture: Texture = load("res://assets/error.png") as Texture
#TODO buttom for svernuty

func _init(
	ctx: Context,
	parent: Component,
	relative_type: int = 0,
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = Vector2.ZERO
).(
	ctx,
	parent,
	relative_type,
	offset,
	custom_size
) -> void:
	set_pivot(Vector2.ZERO)
	list = List.new(ctx, self, Component.Center, Vector2(0, 20))
	list.set_item_aspect(1, 20.0)
	list.set_capacity(3)
	list.set_aligment_type(List.Aligment.Bent)

func render(ctx: Context) -> void:
	if visible():
		ctx.draw_shadowing()
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		var rect: Rect2 = rect()
		ctx.canvas.draw_rect(rect, Color.brown)
		for i in range(0, list.lenght()):
			var card: Card = list.get_item(i)
			card.render(ctx)
#		buttom_exit.render(ctx)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)

#func start_pos() -> Vector2:
#	return Vector2(box.position().x + (box.size().x - _card_size.x * card_count() - _x_indent * card_count() - 1) * 0.5,
#		box.position().y + (box.size().y - _card_size.y) * 0.5)
#
#func card_count() -> int:
#	return _cards.size()
#
#func has_point_on_card(point: Vector2) -> int:
#	var pos := start_pos()
#	for i in range(0, card_count()):
#		if Rect2(pos, _card_size).has_point(point):
#			return i
#		pos.x += _x_offset
#	return -1
#
#func aligment() -> void:
#	var pos := start_pos()
#	for i in range(0, card_count()):
#		_cards[i].set_position(pos)
#		pos.x += _x_offset
#
#func input(sense: Sense) -> void:
##	box.set_hovered(true)
##	if box.is_clicked():
##		sense.send_action(Sense.ScreenSetting)
#	_focused_card_id = has_point_on_card(sense.mouse_pos())
#
#func output(sense: Sense) -> void:
#	_focused_card_id = -1
##	box.set_hovered(false)

