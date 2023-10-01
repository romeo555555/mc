extends Component
class_name Hand

var _texture: Texture
var _max_count := 10
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
#export(bool) var _miroring := false
var _card_size := Vector2(200, 200)
var _card_pivot := _card_size * 0.5
var _x_indent := 0.0
var _hand_twist := 0.15
var _hand_height := 25.0
var _cards: Array
var _margin: Rect2
#var _data
var _cached_card_id: int
var _cached_card_pos: Vector2
var _cached_card_rot: float

func new(
	rect: Rect2, 
	texture: Texture = null,
	x_indent: float = 0, 
	margin_offset: Vector2 = Vector2.ZERO, 
	card_aspect: float = 1
):
	_rect = rect
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_card_size = Vector2(_margin.size.y * card_aspect, _margin.size.y)
	_card_pivot = _card_size * 0.5
	_x_indent = x_indent
	_texture = texture

func card_count() -> int:
	return _cards.size()

func is_full() -> bool:
	return card_count() == _max_count

func is_empety() -> bool:
	return _cards.size() == 0

func add_card(card: Card, idx: int = -1):
	if idx > -1:
		_cards.insert(idx, card)
	else:
		_cards.push_back(card)
	aligment()

func get_card(card_id: int) -> Card:
#	if _cards.has(card_id):
	return _cards[card_id]
#	else:
#		return null

func remove_card(idx: int) -> Card:
	var card: Card = _cards.pop_at(idx)
	aligment()
	return card

func aligment():
#	var count := card_count()
#	var offset := _card_size.x + _x_indent
##	var start_x := (count * offset - _x_indent) * -1
#	var start_x := (count * offset - offset) * -1
#	var x := (_rect.size.x + start_x) * 0.5
#	var angel = -(_hand_twist * count / 2)
#	var y =  _hand_height * count * 0.5
	var count := float(card_count())
#	if count < 4:
#		rovno
	var offset := _card_size.x + _x_indent
	var lenght := (count-1) * offset
#	var start_x := (count * offset - offset) * -1
	var min_x := (_rect.size.x - lenght - _card_size.x) * 0.5 # + _card_size.x * 0.25
	var max_x := min_x + lenght #- _card_size.x * 0.5
#	var min_x := (_rect.size.x - lenght ) * 0.5 # + _card_size.x * 0.25
#	var max_x := min_x + lenght
	var min_a := -0.35
	var max_a := 0.35
	var min_y := _margin.position.y+200
	var max_y := _margin.position.y+200
	
	var angel = -(_hand_twist * count / 2)
#	var y =  _hand_height * count * 0.5
	var curve := Curve2D.new()
	curve.add_point(Vector2(min_x, min_y), Vector2(-122, 243), Vector2(122, -243)) #min_y -200))
	curve.add_point(Vector2(max_x, max_y), Vector2(-122, -243), Vector2(122, 243)) #max_y -200))
#	curve.add_point(Vector2(min_x, min_y), Vector2(-122, -243), Vector2(122, 243)) #max_y -200))
#	curve.add_point(Vector2(max_x, max_y), Vector2(-122, 243), Vector2(122, -243)) #min_y -200))
	var offs_i := 0.0 if card_count() % 2 == 0 else 0.5
	for i in range(0, count):
		var t := float(i+offs_i) / count
		var x: float = lerp(
						min_x,
						max_x,
						t)
#		var y: float = lerp(
#						min_a,
#						max_a,
#						abs(((t * 2.0) / count) - 1.0))
		var a: float = lerp(
						min_a,
						max_a,
						t)
#		if count == 7:
#				print("lerp: ", curve1.interpolate_baked(t),
#					" t: ", t,
#					" i: ", i,
#					"----",t * curve.get_baked_length()
#					)
#		print("angel: ", angel, "height: ", _margin.position.y + abs(y))
#		x += offset
#		angel += _hand_twist
##		print(abs(y))
#		y = y - _hand_height
		var card = _cards[i]
#		card.set_position(Vector2(x, _margin.position.y )) #+ abs(y)
		var pos := curve.interpolate_baked(t * curve.get_baked_length(), false)
		card.set_position(pos)
		card.set_rotation(a) #ngel)
	print("stop" )

func has_point_on_card(point: Vector2) -> int:
	for i in range(0, card_count()):
		var card: Card = _cards[i]
		if card.visible():
#		ctx.draw_set_transform(card.position() + _card_pivot, card.rotation(), card.scale())
#		ctx.draw_rect(Rect2(Vector2.ZERO - _card_pivot, _card_size), Color.blue, false, 15)
#		ctx.draw_circle(point, 15, Color.red)
#		ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
			if Transform2D(card.rotation(), card.position() + _card_pivot).xform(Rect2(Vector2.ZERO - _card_pivot, _card_size)).has_point(point):
				return i
	return -1

#func has_point(point: Vector2) -> bool:
#	#TODO: what about scale?
##	var mpoint: Vector2 = Transform2D(_rotation, _position + _pivot).xform(point - _position - _pivot) #_position + _pivot-point)
##	_position = mpoint
##	return  Rect2(Vector2.ZERO - _pivot, _size).has_point(mpoint)
#	return Transform2D(_rotation, _position + _pivot).xform(Rect2(Vector2.ZERO - _pivot, _size)).has_point(point)
##	return  Rect2(_position, _size).has_point(point)

#func input(sense: Sense):
#	_hovered = true
#	if _clicked:
#		sense.send_action(Sense.EndTurn)
#
#func output(sense: Sense):
#	_hovered = false

func input(sense: Sense):
	var card_id := has_point_on_card(sense.mouse_pos())
	sense.set_card_id(card_id)
#	if sense.clicked():
#	sense.input_event(sense.MouseEnter, Hand, player_id, card_id, can_drag)

func output(sense: Sense):
#	aligment()
	pass

func highlight_reset():
	for card in _cards:
		card.set_highlight(false)

func hover_on(card_id: int):
	_cards[card_id].set_highlight(true, Color.aqua)

func hover_off(card_id: int):
	_cards[card_id].set_highlight(false)

func remove_select_card() -> Card:
	return remove_card(_cached_card_id)

func select_card(card_id: int):
	var card: Card = _cards[card_id]
	_cached_card_id = card_id
	_cached_card_pos = card.position()
	_cached_card_rot = card.rotation()
	card.set_visible(false)
	card.set_rotation(0)
	card.set_scale(Vector2.ONE)

func unselect_card():
	var card: Card = _cards[_cached_card_id]
	card.set_visible(true)
	card.set_position(_cached_card_pos)
	card.set_rotation(_cached_card_rot)
	card.set_scale(Vector2.ONE)

func draw_select_card(ctx: CanvasItem, position: Vector2):
	var card: Card = _cards[_cached_card_id]
	card.set_visible(true)
	card.set_position(position-_card_pivot)
	ctx.draw_card(card, _card_size)
	card.set_visible(false)

func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	for i in range(card_count() - 1, -1, -1):
		var card: Card = _cards[i]
		ctx.draw_card(card, _card_size)
	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

#	ctx.draw_hovered(_rect, _hovered, _clicked)
