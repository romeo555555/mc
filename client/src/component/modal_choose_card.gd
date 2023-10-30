extends Component
class_name ModalChooseCard

var box: Box = Box.new()
var list: List = List.new()
var texture: Texture = load("res://assets/error.png") as Texture

var _card_size: Vector2
var _x_indent: float
var _x_offset: float
var _cards: Array
var _focused_card_id: int = -1
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
	pass

func init(screen_size: Vector2, size: Vector2, card_size: Vector2, x_indent: float = 10) -> void:
	var card_count := 3
	box.init((screen_size - size) * 0.5, size)
	_card_size = card_size
	_x_indent = x_indent
	_x_offset = card_size.x + x_indent
	
	var cards: Array = []
	for i in range(0, card_count):
		var card: Card = Card.new()
		card.init()
		cards.push_back(card)
	setup(cards)

func setup(cards: Array) -> void:
	_cards = cards
	aligment()

func start_pos() -> Vector2:
	return Vector2(box.position().x + (box.size().x - _card_size.x * card_count() - _x_indent * card_count() - 1) * 0.5,
		box.position().y + (box.size().y - _card_size.y) * 0.5)

func card_count() -> int:
	return _cards.size()

func has_point_on_card(point: Vector2) -> int:
	var pos := start_pos()
	for i in range(0, card_count()):
		if Rect2(pos, _card_size).has_point(point):
			return i
		pos.x += _x_offset
	return -1

func aligment() -> void:
	var pos := start_pos()
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
