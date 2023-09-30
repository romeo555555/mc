extends Object
class_name Render

static func buttom(ctx: CanvasItem, text: String, font_size: int, rect: Rect2, texture: Texture = load("res://assets/error.png") as Texture):
#	ctx.draw_texture_rect(texture, rect, false)
	ctx.draw_rect(rect, Color.violet)
	ctx.font.set_size(font_size)
	var h_font_size = font_size * 0.5
	ctx.draw_string(ctx.font, rect.get_center() - ctx.font.get_string_size(text) * 0.5 + Vector2(0, h_font_size), text)

static func setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
	var buttom_count := 3
	var y_offset := margin.size.y + indent
	var brect := Rect2(margin.position, Vector2(margin.size.x, margin.size.y / buttom_count - indent))
	ctx.draw_rect(rect, Color.brown)
	buttom(ctx, "Play", font_size, brect)
	brect.position.y += y_offset
	buttom(ctx, "Setting", font_size, brect)
	brect.position.y += y_offset
	buttom(ctx, "Exit", font_size, brect)

#var _max_row_count := 9
#var _row_count := 0
#var _card_size := Vector2(200, 200)
#var _card_indent := Vector2(10, 10)
#static func deck(ctx: CanvasItem, cards: Array, max_row_count: int):
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

#static func take_card_screen(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#				ctx.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), card.highlight_color(), false, 15)
#	for i in range(3):
#		draw_card(ctx, card, card_size)

static func shadowing(ctx: CanvasItem, screen_size: Vector2):
	ctx.draw_rect(Rect2(Vector2.ZERO, screen_size), Color(0,0,0, 0.5))

static func zoom_card(ctx: CanvasItem, card: Card, card_size: Vector2):
	draw_card(ctx, card, card_size)

static func draw_card(ctx: CanvasItem, card: Card, card_size: Vector2):
	if card.visible():
		var card_pivot := card_size * 0.5 #* _scale
		ctx.draw_set_transform(card.position() + card_pivot, card.rotation(), card.scale())
		ctx.draw_texture_rect(card.texture(), Rect2(Vector2.ZERO - card_pivot, card_size), false)
		#	ctx.draw_rect()
		#	ctx.draw_string()
		if card.highlight():
			ctx.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), card.highlight_color(), false, 15)
