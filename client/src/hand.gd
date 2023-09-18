extends View
class_name Hand

var _max_size := 10
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

func setup(
	rect: Rect2, 
	texture: Texture = null,
	x_indent: float = 0, 
	margin_offset: Vector2 = Vector2.ZERO, 
	card_aspect: float = 1
):
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_card_size = Vector2(_margin.size.y * card_aspect, _margin.size.y)
	_card_pivot = _card_size * 0.5
	_x_indent = x_indent
	_texture = texture
	_rect = rect
	_type = "Hand".hash()

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func has_point_on_card(point: Vector2) -> int:
	for i in range(0, card_count()):
		var card: Card = _cards[i]
		if 	Transform2D(card.rotation(), card.position() + _card_pivot).xform(Rect2(Vector2.ZERO - _card_pivot, _card_size)).has_point(point):
			return i
	return -1

func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	for card in _cards:
		if card.visible():
			#	var _pivot := size * 0.5 * _scale
			ctx.draw_set_transform(card.position() + _card_pivot, card.rotation(), card.scale())
			ctx.draw_texture_rect(card.texture(), Rect2(Vector2.ZERO - _card_pivot, _card_size), false)
			#	ctx.draw_rect()
			#	ctx.draw_string()
			if card.hightlight():
				ctx.draw_rect(Rect2(Vector2.ZERO - _card_pivot, _card_size), card.hightlight_color(), false, 15)
	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func card_count() -> int:
	return _cards.size()

func can_add_card() -> bool:
	return !card_count() == _max_size

func add_card(card: Card):
	_cards.push_back(card)
	aligment()

#func get_card(card_id: int) -> Node:
#	return get_child(card_id)
#
#func remove_card_right(idx: int):
##	if idx == _avatar_id:
##		return
#	remove_child(get_child(idx))

#func has_point(point: Vector2) -> bool:
#	#TODO: what about scale?
##	var mpoint: Vector2 = Transform2D(_rotation, _position + _pivot).xform(point - _position - _pivot) #_position + _pivot-point)
##	_position = mpoint
##	return  Rect2(Vector2.ZERO - _pivot, _size).has_point(mpoint)
#	return Transform2D(_rotation, _position + _pivot).xform(Rect2(Vector2.ZERO - _pivot, _size)).has_point(point)
##	return  Rect2(_position, _size).has_point(point)

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

func higlight_reset():
	for card in _cards:
		card.set_hightlight(false)

func hover_on(card_id: int):
	_cards[card_id].set_hightlight_color(Color.aqua)

func hover_off(card_id: int):
	_cards[card_id].set_hightlight(true)

