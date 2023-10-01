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

