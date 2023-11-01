extends Control #Component
class_name ModalScrollList

var component: Component
var ctx: Context
var g_canvas: CanvasItem
var list: List
var texture: Texture = load("res://assets/error.png") as Texture
var buttom_back: Buttom

#var _margin_offset: Vector2
#var _card_size: Vector2
#var _indent: Vector2
#var _offset: Vector2
#var _cards: Array
#var _max_row_count: int = 5
##var _rect_min_size: Vector2
#var _focused_card_id: int = -1


func _init(
	ctx: Context,
	parent: Component,
	relative_type: int = 0,
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = Vector2.ZERO
#).(
#	ctx,
#	parent,
#	relative_type,
#	offset,
#	custom_size
) -> void:
	component = Component.new(ctx, parent, relative_type, offset, custom_size)
	component.set_pivot(Vector2.ZERO)
	list = List.new(ctx, component, Component.Center, Vector2(0, 20))
#	list.set_item_aspect(0.1, 20.0)
	list.set_item_size(Vector2(200, 200), Vector2(20, 20))
	list.set_capacity(3)
	list.set_aligment_type(List.Aligment.Grid)
#	buttom = Buttom.new()

func render(context: Context) -> void:
	ctx = context
	g_canvas = context.canvas
	update()

func _draw() -> void:
	if not ctx:
		return
	ctx.canvas = self as CanvasItem
	if component.visible():
#		ctx.draw_shadowing()
		ctx.canvas.draw_set_transform(component.center(), component.rotation(), component.scale())
		var rect: Rect2 = component.rect()
		ctx.canvas.draw_rect(rect, Color.brown)
		for i in range(0, list.lenght()):
			var card: Card = list.get_item(i)
			card.render(ctx)
#		buttom_exit.render(ctx)

		var last_comp: Component = list.get_last_item()
		rect_min_size = last_comp.position() + last_comp.size() #+ _indent + Vector2(0, _margin_offset.y)
#		box.init(box.position(), Vector2(box.size().x, rect_min_size.y + _margin_offset.y))
#		box.init(box.position(), Vector2(box.size().x, rect_min_size.y + _margin_offset.y))
		component.set_size(Vector2(component.size().x, rect_min_size.y))
		
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
	ctx.canvas = g_canvas

#	self.draw_rect(box.rect(), Color.brown)
#	for i in range(list.size() - 1, -1, -1):
#		var card: Card = list.get_card(i)
#		card.draw(self, list.card_size())
#	self.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

	#todo
#	if list.get_focused_card_id() > -1:
#		var card: Card = list.get_focused_card()
#		var box: Box = Box.new()
#		box.set_rect(Rect2(card.position(), list.card_size()))
#		box.set_hovered(true)
#		self.draw_hovered(box)
#	_buttom_back.draw(self)

#var _max_row_count := 9
#var _row_count := 0
#var _card_size := Vector2(200, 200)
#var _card_indent := Vector2(10, 10)
#func deck(ctx: CanvasItem, cards: Array, max_row_count: int):
#	var current_row_count := 0
#	var _last_colum_count = cards.size() % max_row_count
#	if _last_colum_count == 0:
#		_row_count += 1
##		rect_min_size = Vector2(1000, 1000)
#	var pos := _card_indent + (_card_size + _card_indent) \
#	 * Vector2(_last_colum_count, _row_count) - Vector2(0, _card_size.y)
#	if pos.y + _card_size.y + _card_indent.y > rect_min_size.y:
#		rect_min_size.y += _card_size.y + _card_indent.y
#	card.set_position(pos)
#	add_child(card)

#func aligment() -> void:
##	var pos := _start_pos
#	var row := 0
#	for i in range(0, card_count()):
#		var colum := int(i) % _max_row_count
#		print(colum)
#		_cards[i].set_position(Vector2(box.position().x + _margin_offset.x + _offset.x * colum,
#			box.position().y + _margin_offset.y + _offset.y * row))
#		_cards[i].set_rotation(0)
#		if colum == 4:
#			row += 1
#	rect_min_size = _cards[card_count()-1].position() + _card_size + _indent + Vector2(0, _margin_offset.y)
#	box.init(box.position(), Vector2(box.size().x, rect_min_size.y + _margin_offset.y))
##	rect_min_size = Vector2(1000, 2000)
##	var _last_colum_count = _cards.size() % _max_row_count
##	if _last_colum_count == 0:
##		_row_count += 1
##	var pos := _card_indent + (_card_size + _card_indent) \
##	 * Vector2(_last_colum_count, _row_count) - Vector2(0, _card_size.y)
###		rect_min_size = Vector2(1000, 1000)
##	_rect_min_size = pos + _card_size + _card_indent
##	card.set_position(pos)
##	card.set_rotation(0)
