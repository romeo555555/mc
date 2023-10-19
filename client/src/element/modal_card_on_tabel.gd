extends Object
class_name ModalCardOnTabel

var box: Box = Box.new()
var _start_pos: Vector2
var _texture: Texture
var _card_size: Vector2
var _x_indent: float
var _x_offset: float
var _cards: Array
var _focused_card_id: int = -1
#TODO buttom for svernuty

func init(screen_size: Vector2, size: Vector2, card_size: Vector2, x_indent: float = 10, texture: Texture = load("res://assets/error.png") as Texture) -> void:
	var card_count := 3
	box.init((screen_size - size) * 0.5, size)
	_start_pos = Vector2(box.rect().position.x + (size.x - card_size.x * card_count - x_indent * card_count - 1) * 0.5,
		box.rect().position.y + (size.y - card_size.y) * 0.5)
	_card_size = card_size
	_x_indent = x_indent
	_x_offset = card_size.x + x_indent
	_texture = texture
	for i in range(0, card_count):
		var card: Card = Card.new()
		card.init()
		_cards.push_back(card)
	aligment()

func card_count() -> int:
	return _cards.size()

func has_point_on_card(point: Vector2) -> int:
	var pos := _start_pos
	for i in range(0, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += _x_offset
	return -1

func aligment() -> void:
	var pos := _start_pos
	for i in range(0, card_count()):
		_cards[i].set_position(pos)
		pos.x += _x_offset

func input(sense: Sense) -> void:
#	box.set_hovered(true)
#	if box.is_clicked():
#		sense.send_action(Sense.ScreenSetting)
	_focused_card_id = has_point_on_card(sense.mouse_pos())

func output(sense: Sense) -> void:
	_focused_card_id = -1
#	box.set_hovered(false)

func draw(ctx: CanvasItem) -> void:
	#func draw_buttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#	ctx.draw_shadowing()
	ctx.draw_rect(box.rect(), Color.brown)
	for card in _cards:
		card.draw(ctx, _card_size)
