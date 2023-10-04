extends Component
class_name Deck

var screen: Screen
var _texture: Texture

var _max_row_count := 9
var _row_count := 0
var _card_size := Vector2(200, 200)
var _card_indent := Vector2(10, 10)
var _cards: Array = []
var _rect_min_size: Vector2

func init(pos: Vector2, size: Vector2, texture: Texture = load("res://assets/error.png") as Texture):
	_texture = texture
	_rect = Rect2(pos, size)

func input(sense: Sense):
	_hovered = true
	if sense.clicked():
		sense.set_event(Sense.Screen.Deck)
	pass

func output(sense: Sense):
	_hovered = false

func draw(ctx: CanvasItem):
#	if _texture:
	ctx.draw_texture_rect(_texture, _rect, false)
	ctx.draw_hovered(_rect, _hovered, _clicked)	

func add_card(card: Card):
	var _last_colum_count = _cards.size() % _max_row_count
	if _last_colum_count == 0:
		_row_count += 1
	var pos := _card_indent + (_card_size + _card_indent) \
	 * Vector2(_last_colum_count, _row_count) - Vector2(0, _card_size.y)
#		rect_min_size = Vector2(1000, 1000)
	_rect_min_size = pos + _card_size + _card_indent
	card.set_position(pos)
	card.set_rotation(0)
	_cards.push_back(card)

#func remove_card(card: Control):
#	var _last_colum_count = card_count() % _max_row_count
#	print("colum", _last_colum_count)
#	if _last_colum_count == 0:
#		_row_count += 1
#	var pos := _card_indent + (_card_size + _card_indent) \
#	 * Vector2(_last_colum_count, _row_count) 
#	add_child(card)
#	card.set_position(pos)

#func card_count() -> int:
#	return get_child_count()

#func aligment():
#	var count := card_count()
#	var offset := _card_size.x + _card_indent.x
#	var start_x := (count * offset - _card_indent.x) * -1
#	var x := (rect_size.x + start_x) * 0.5
#	for i in range(2, count):
#		get_child(i).set_position(Vector2(x, 0))
#		x += offset

class Screen extends Component:
	var _texture: Texture

	func new(rect: Rect2):
		_rect = rect

	func input(sense: Sense):
		pass

	func output(sense: Sense):
		pass

	func draw(ctx: CanvasItem):
	#	if _sense_rect.focused:
			#hovered ctx.hovered_color
		pass


