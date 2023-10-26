extends Control
class_name ModalScrollList

var ctx: CanvasItem = null
var config: Config
var _visible := false

#func _process(delta) -> void:
#	if _visible:
#		update()
var screen_size: Vector2
var box: Box = Box.new()
var list: List = List.new()
var texture: Texture = load("res://assets/error.png") as Texture

var _margin_offset: Vector2
var _card_size: Vector2
var _indent: Vector2
var _offset: Vector2
var _cards: Array
var _max_row_count: int = 5
#var _rect_min_size: Vector2
var _focused_card_id: int = -1

var _buttom_back: Buttom = Buttom.new()

func set_setting(setting: Setting) -> void:
	setting = setting

func init(screen_size: Vector2, margin_offset: Vector2, card_size: Vector2, indent: Vector2 = Vector2(10,10)) -> void:
	_margin_offset = margin_offset
	_card_size = card_size
	_indent = indent
	_offset = card_size + indent
	var size: Vector2 = Vector2(_offset.x * _max_row_count + margin_offset.x * 2, screen_size.y - margin_offset.y * 2)
	box.init((screen_size - size) * 0.5, size)
	var buttom_size := Vector2(200,100)
	_buttom_back.init(screen_size - buttom_size, buttom_size, "Back")

func setup(cards: Array) -> void:
	_cards = cards
	list.aligment()

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

func draw(ctx: CanvasItem) -> void:
#	ctx = ctx
	update()
func _draw() -> void:
	#func draw_buttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#	ctx.draw_shadowing()
	self.draw_rect(box.rect(), Color.brown)
	for i in range(list.size() - 1, -1, -1):
		var card: Card = list.get_card(i)
		card.draw(self, list.card_size())
	self.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	#todo
#	if list.get_focused_card_id() > -1:
#		var card: Card = list.get_focused_card()
#		var box: Box = Box.new()
#		box.set_rect(Rect2(card.position(), list.card_size()))
#		box.set_hovered(true)
#		self.draw_hovered(box)
	_buttom_back.draw(self)

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
