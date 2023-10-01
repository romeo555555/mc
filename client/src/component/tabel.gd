extends Component
class_name Tabel

#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
#export(bool) var _miroring := false
#var _card_size := Vector2(200, 200)
var _texture: Texture
var _margin: Rect2
var _card_size := Vector2.ZERO
var _card_pivot := Vector2.ZERO
var _avatar_rect: Rect2
var _avatar_pivot := Vector2.ZERO
var _x_indent := 0.0
var _avatar_card: Card
var left_line: Line
var right_line: Line

#var _left_count := 0
#var _right_count := 0
#var _avatar_id := 0
#var _cards: Array

var _cached_start_pos := Vector2.ZERO
var _cached_player_id: String
var _cached_view_id: int = 0
var _cached_card_id: int
var _targeting_player_id: String
var _targeting_view_id: int = 0
var _targeting_card_id: int = -1
var _arrow: Line2D = null
#var _data

func setup(
	rect: Rect2, 
	texture: Texture = null,
	arrow: Line2D = null,
	avatar: Card = null,
	x_indent: float = 0, 
	margin_offset: Vector2 = Vector2.ZERO, 
	card_aspect_x: float = 1,
	avatar_aspect_y: float = 1.25
):
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_card_size = Vector2(_margin.size.y * card_aspect_x, _margin.size.y)
	_card_pivot = _card_size * 0.5
	_x_indent = x_indent
	var avatar_size: Vector2 = Vector2(_card_size.x, _card_size.y * avatar_aspect_y)
	_avatar_rect = Rect2(Vector2(rect.position.x + (rect.size.x - _card_size.x) * 0.5, 
		rect.position.y + (rect.size.y - avatar_size.y) * 0.5), avatar_size)
	_avatar_pivot = avatar_size * 0.5
	avatar.set_position(_avatar_rect.position)
	_avatar_card = avatar
	left_line = Line.new()
	right_line = Line.new()
	var center_tabel := Vector2(rect.position.x + rect.size.x * 0.5, _margin.position.y)
	right_line.setup(center_tabel, 4, Vector2(_avatar_rect.end.x + _x_indent, _margin.position.y), _card_size.x + _x_indent)
	center_tabel.x -= _card_size.x
	left_line.setup(center_tabel, 4, Vector2(_avatar_rect.position.x - _card_size.x - _x_indent, _margin.position.y), -1 * (_card_size.x + _x_indent))
#	avatar.setup(Rect2(rect.position + Vector2((rect.size.x - _card_size.x) * 0.5, 0), _card_size))
	_arrow = arrow
	_texture = texture
	_rect = rect

func line_has_point(point: Vector2) -> int:
	if _rect.position.x + _rect.size.x * 0.5 < point.x:
		return Sense.R_Tabel
	return Sense.L_Tabel

func line(view_id) -> Line:
	if view_id == Sense.R_Tabel:
		return right_line
	elif view_id == Sense.L_Tabel:
		return left_line
	return null

func input(sense: Sense):
	var line_id := line_has_point(sense.mouse_pos())
	var line: Line = line(line_id)
	if line:
		line.input(sense, _card_size)
		sense.set_view_id(line_id)

func targeting(sense: Sense):
	var line_id := line_has_point(sense.mouse_pos())
	var line: Line = line(line_id)
	if line:
		line.input(sense, _card_size)
		sense.set_view_id(line_id)
		target_card(sense)

func dragging(sense: Sense):
	var line_id := line_has_point(sense.mouse_pos())
	var line: Line = line(line_id)
	if line:
		line.dragging(sense, _card_size)
		sense.set_view_id(line_id)
#		return true
#	return false

func output(sense: Sense):
	var line: Line = line(sense.prev_view_id())
	if line:
		if sense.targeting():
			untarget_card()
		line.aligment()

func target_card(sense: Sense):
	_targeting_player_id = sense.player_id()
	_targeting_view_id = sense.view_id()
	_targeting_card_id = sense.card_id()
	if _targeting_card_id == -1:
		return
	if _targeting_player_id == _cached_player_id and _targeting_view_id == _cached_view_id \
	and _targeting_card_id == _cached_card_id:
		return
	var line: Line = line(_targeting_view_id)
	if line:
		var card: Card = line._cards[_targeting_card_id]
		card.set_highlight(true, Color.red)

func untarget_card():
	if _targeting_card_id == -1:
		return
	if _targeting_player_id == _cached_player_id and _targeting_view_id == _cached_view_id \
	and _targeting_card_id == _cached_card_id:
		return
	var line: Line = line(_targeting_view_id)
	if line:
		var card: Card = line._cards[_targeting_card_id]
		_targeting_card_id = -1
		card.set_highlight(false, Color.aliceblue)

func unhighlight_all_card():
	for card in left_line._cards:
		card.set_highlight(false)
	for card in right_line._cards:
		card.set_highlight(false)

func targeting_arrow(screen_size: Vector2, mouse_pos: Vector2):
	_arrow.clear_points()
	var curve = Curve2D.new()
	curve.add_point(
			_cached_start_pos,
#			screen_size/2,
			Vector2(0,0),
#			TODO:
#			(board._rect.size/2).direction_to(get_viewport().size/2) * 75)
			(screen_size/2).direction_to(screen_size/2) * 75)
	curve.add_point(mouse_pos,
			Vector2(0, 0), Vector2(0, 0))
	_arrow.set_points(curve.get_baked_points())
	
#	var card: Card = _cards[_cached_card_id]
#	card.set_visible(true)
#	card.set_position(position-_card_pivot)
#	draw_card(ctx, card)
#	card.set_visible(false)

func select_card(sense: Sense):
	var line: Line = line(sense.view_id())
	if line:
		var card: Card = line._cards[sense.card_id()]
		_cached_start_pos = card.position() + _card_pivot
		_cached_player_id = sense.player_id()
		_cached_view_id = sense.view_id()
		_cached_card_id = sense.card_id()
		card.set_highlight(true)
		_arrow.set_visible(true)

func unselect_card():
	var line: Line = line(_cached_view_id)
	if line:
		var card: Card = line._cards[_cached_card_id]
		_cached_card_id = -1
		card.set_highlight(false)
		_arrow.set_visible(false)
	
func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	draw_card(ctx, _avatar_card, _avatar_rect.size, _avatar_pivot)
	for i in range(0, left_line.card_count()):
		draw_card(ctx, left_line._cards[i], _card_size, _card_pivot)
	for i in range(0, right_line.card_count()):
		draw_card(ctx, right_line._cards[i], _card_size, _card_pivot)
#	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
#	avatar.draw(ctx, font)

func draw_card(ctx: CanvasItem, card: Card, card_size: Vector2, card_pivot: Vector2):
	if card.visible():
		var font: DynamicFont = ctx.font
	#	var _pivot := size * 0.5 * _scale
#		ctx.draw_set_transform(card.position + _card_pivot, card.rotation, card.scale)
#		ctx.draw_texture_rect(_texture, Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
		ctx.draw_texture_rect(card.texture(), Rect2(card.position(), card_size), false)
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.draw_string(font, card.position() - Vector2(0, 16), "Bill Amstrong")
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color(255, 0 ,0))
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color(219, 172 ,0))
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color(163, 0 ,242))
		ctx.draw_rect(Rect2(card.position() - Vector2(0, 56), Vector2(card_size.x, 42)), Color.black)
		ctx.draw_string(font, card.position() - Vector2(0, 16), "3000")
		if card.highlight():
			ctx.draw_rect(Rect2(card.position(), card_size), card.highlight_color(), false, 30)

