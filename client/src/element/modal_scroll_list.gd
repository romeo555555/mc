extends Control
class_name ModalScrollList

var _visible := false

#func _process(delta) -> void:
#	if _visible:
#		update()
var screen_size: Vector2
var box: Box = Box.new()
var _margin_offset: Vector2
var _texture: Texture
var _card_size: Vector2
var _indent: Vector2
var _offset: Vector2
var _cards: Array
var _max_row_count: int = 5
#var _rect_min_size: Vector2
var _focused_card_id: int = -1
var _buttom_back: Buttom = Buttom.new() 

func init(screen_size: Vector2, margin_offset: Vector2, card_size: Vector2, indent: Vector2 = Vector2(10,10), texture: Texture = load("res://assets/error.png") as Texture) -> void:
	_margin_offset = margin_offset
	_card_size = card_size
	_indent = indent
	_offset = card_size + indent
	_texture = texture
	var size: Vector2 = Vector2(_offset.x * _max_row_count + margin_offset.x * 2, screen_size.y - margin_offset.y * 2)
	box.init((screen_size - size) * 0.5, size)
	var buttom_size := Vector2(200,100)
	_buttom_back.init(screen_size - buttom_size, buttom_size, "Back")

func setup(cards: Array) -> void:
	_cards = cards
	aligment()

func card_count() -> int:
	return _cards.size()

func has_point_on_card(point: Vector2) -> int:
	for i in range(0, card_count()):
		if Rect2(_cards[i].position(), _card_size).has_point(point):
			return i
	return -1

func aligment() -> void:
#	var pos := _start_pos
	var row := 0
	for i in range(0, card_count()):
		var colum := int(i) % _max_row_count
		print(colum)
		_cards[i].set_position(Vector2(box.position().x + _margin_offset.x + _offset.x * colum,
			box.position().y + _margin_offset.y + _offset.y * row))
		_cards[i].set_rotation(0)
		if colum == 4:
			row += 1
	rect_min_size = _cards[card_count()-1].position() + _card_size + _indent + Vector2(0, _margin_offset.y)
	box.init(box.position(), Vector2(box.size().x, rect_min_size.y + _margin_offset.y))
#	rect_min_size = Vector2(1000, 2000)
#	var _last_colum_count = _cards.size() % _max_row_count
#	if _last_colum_count == 0:
#		_row_count += 1
#	var pos := _card_indent + (_card_size + _card_indent) \
#	 * Vector2(_last_colum_count, _row_count) - Vector2(0, _card_size.y)
##		rect_min_size = Vector2(1000, 1000)
#	_rect_min_size = pos + _card_size + _card_indent
#	card.set_position(pos)
#	card.set_rotation(0)

func input(sense: Sense) -> void:
#	box.set_hovered(true)
#	if box.is_clicked():
#		sense.send_action(Sense.ScreenSetting)
	_focused_card_id = has_point_on_card(sense.mouse_pos())

func output(sense: Sense) -> void:
	_focused_card_id = -1
#	box.set_hovered(false)

func _draw() -> void:
	#func draw_buttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#	ctx.draw_shadowing()
	self.draw_rect(box.rect(), Color.brown)
	for card in _cards:
		card.draw(self, _card_size)
	_buttom_back.draw(self)
