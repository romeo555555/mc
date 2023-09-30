extends Control

var _max_row_count := 9
var _row_count := 0
var _card_size := Vector2(200, 200)
var _card_indent := Vector2(10, 10)
var _cards: Array
var _visible := false

func setup(cards: Array):
#	if _rect_min_size.y > rect_min_size.y:
#		rect_min_size.y += _card_size.y + _card_indent.y
	_visible = true
	set_visible(_visible)
	_cards = cards
	

func _process(delta):
	if _visible:
		update()

func _draw():
##	if _texture:
#	ctx.draw_texture_rect(_texture, _rect, false)
#	if _highlight:
#		ctx.draw_rect(_rect, _highlight_color, false, 30)
##		_highlight = false

	for card in _cards:
		Render.draw_card(self, card, _card_size)
#	ctx.scroll_container.draw_texture_rect(_texture, _rect, false)
#	ctx.scroll_container.sev_visible()
	
#func _ready():
#	pass

func add_card(card: Control):
	var _last_colum_count = card_count() % _max_row_count
	if _last_colum_count == 0:
		_row_count += 1
#		rect_min_size = Vector2(1000, 1000)
	var pos := _card_indent + (_card_size + _card_indent) \
	 * Vector2(_last_colum_count, _row_count) - Vector2(0, _card_size.y)
	if pos.y + _card_size.y + _card_indent.y > rect_min_size.y:
		rect_min_size.y += _card_size.y + _card_indent.y
	card.set_position(pos)
	add_child(card)

#func remove_card(card: Control):
#	var _last_colum_count = card_count() % _max_row_count
#	print("colum", _last_colum_count)
#	if _last_colum_count == 0:
#		_row_count += 1
#	var pos := _card_indent + (_card_size + _card_indent) \
#	 * Vector2(_last_colum_count, _row_count) 
#	add_child(card)
#	card.set_position(pos)

func card_count() -> int:
	return get_child_count()

#func aligment():
#	var count := card_count()
#	var offset := _card_size.x + _card_indent.x
#	var start_x := (count * offset - _card_indent.x) * -1
#	var x := (rect_size.x + start_x) * 0.5
#	for i in range(2, count):
#		get_child(i).set_position(Vector2(x, 0))
#		x += offset
