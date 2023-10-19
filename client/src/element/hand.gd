extends Object
class_name Hand

var box: Box = Box.new()
var _miroring := false
var _texture: Texture
var _max_count := 10
#export(bool) var _can_drag := false
#export(bool) var _can_drop := false
var _start_pos := Vector2.ZERO
var _card_size := Vector2(200, 200)
var _card_pivot := _card_size * 0.5
var _x_indent := 0.0
var _hand_twist := 0.15
var _hand_height := 25.0
var _cards: Array
#var _data
var _focused_card_id: int = -1

var _cached_card_id: int
var _cached_card_pos: Vector2
var _cached_card_rot: float


func init(
	miroring: bool,
	pos: Vector2,
	size: Vector2,
	texture: Texture = null,
	card_size: Vector2 = Vector2(200, 200),
	x_indent: float = 0,
	start_offset: Vector2 = Vector2.ZERO
) -> void:
	box.init(pos, size)
	_start_pos = pos + start_offset
	_card_size = card_size
	_card_pivot = _card_size * 0.5
	_x_indent = x_indent
	_texture = texture
	_miroring = miroring

func card_count() -> int:
	return _cards.size()

func is_full() -> bool:
	return card_count() == _max_count

func is_empety() -> bool:
	return _cards.size() == 0

func add_card(card: Card, idx: int = -1) -> void:
	if idx > -1:
		_cards.insert(idx, card)
	else:
		_cards.push_back(card)
	aligment()

func get_card(card_id: int) -> Card:
	return _cards[card_id]

func remove_card(idx: int) -> Card:
	var card: Card = _cards.pop_at(idx)
	aligment()
	return card

func aligment() -> void:
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
	var min_x := (box.size().x - lenght - _card_size.x) * 0.5 # + _card_size.x * 0.25
	var max_x := min_x + lenght #- _card_size.x * 0.5
#	var min_x := (_rect.size.x - lenght ) * 0.5 # + _card_size.x * 0.25
#	var max_x := min_x + lenght
	var min_a := -0.35
	var max_a := 0.35
	
	var angel = -(_hand_twist * count / 2)
#	var y =  _hand_height * count * 0.5
	var curve := Curve2D.new()
	if _miroring:
		var min_y := _start_pos.y+200
		var max_y := _start_pos.y+200
		curve.add_point(Vector2(min_x, min_y), Vector2(-122, 243), Vector2(122, -243)) #min_y -200))
		curve.add_point(Vector2(max_x, max_y), Vector2(-122, -243), Vector2(122, 243)) #max_y -200))
	else:
		var min_y := _start_pos.y-200
		var max_y := _start_pos.y-200
		curve.add_point(Vector2(max_x, max_y), Vector2(-122, -243), Vector2(122, 243)) #max_y -200))
		curve.add_point(Vector2(min_x, min_y), Vector2(-122, 243), Vector2(122, -243)) #min_y -200))
	
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
		var card = _cards[i]
#		card.set_position(Vector2(x, _margin.position.y )) #+ abs(y)
		var pos := curve.interpolate_baked(t * curve.get_baked_length(), false)
		card.set_position(pos)
		card.set_rotation(a) #ngel)

func has_point_on_card(point: Vector2) -> int:
	for i in range(0, card_count()):
		var card: Card = _cards[i]
		if card.visible():
#		#debug
#		ctx.draw_set_transform(card.position() + _card_pivot, card.rotation(), card.scale())
#		ctx.draw_rect(Rect2(Vector2.ZERO - _card_pivot, _card_size), Color.blue, false, 15)
#		ctx.draw_circle(point, 15, Color.red)
#		ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
#		#TODO: what about scale?
#		var mpoint: Vector2 = Transform2D(_rotation, _position + _pivot).xform(point - _position - _pivot) #_position + _pivot-point)
#		_position = mpoint
#		return  Rect2(Vector2.ZERO - _pivot, _size).has_point(mpoint)
#		return Transform2D(_rotation, _position + _pivot).xform(Rect2(Vector2.ZERO - _pivot, _size)).has_point(point)
#		return  Rect2(_position, _size).has_point(point)
			if Transform2D(card.rotation(), card.position() + _card_pivot).xform(Rect2(Vector2.ZERO - _card_pivot, _card_size)).has_point(point):
				return i
	return -1


func input(sense: Sense) -> void:
#		box.set_hovered(true)
#	if box.is_clicked():
	_focused_card_id = has_point_on_card(sense.mouse_pos())
#	sense.set_card_id(_focused_card_id)
#	if _clicked:
#	sense.input_event(sense.MouseEnter, Hand, player_id, card_id, can_drag)

func output(sense: Sense) -> void:
#		box.set_hovered(false)
#	aligment()
	_focused_card_id = -1
	pass



func highlight_reset() -> void:
	for card in _cards:
		card.set_highlight(false)

func hover_on(card_id: int) -> void:
	_cards[card_id].set_highlight(true, Color.aqua)

func hover_off(card_id: int) -> void:
	_cards[card_id].set_highlight(false)



func focused_card() -> int:
	return _focused_card_id

func cached_card(card_id: int) -> void:
	var card: Card = _cards[card_id]
	_cached_card_id = card_id
	_cached_card_pos = card.position()
	_cached_card_rot = card.rotation()
	card.set_visible(false)
	card.set_rotation(0)
	card.set_scale(Vector2.ONE)

func uncached_card() -> void:
	var card: Card = _cards[_cached_card_id]
	card.set_visible(true)
	card.set_position(_cached_card_pos)
	card.set_rotation(_cached_card_rot)
	card.set_scale(Vector2.ONE)

func get_cached_card() -> Card:
	return get_card(_cached_card_id)

func remove_cached_card() -> Card:
	return remove_card(_cached_card_id)

func draw_cached_card(ctx: CanvasItem, position: Vector2) -> void:
	var card: Card = _cards[_cached_card_id]
	card.set_visible(true)
	card.set_position(position - _card_pivot)
	card.draw(ctx, _card_size)
	card.set_visible(false)

func draw(ctx: CanvasItem) -> void:
	if _texture:
		ctx.draw_texture_rect(_texture, box.rect(), false)
	for i in range(card_count() - 1, -1, -1):
		var card: Card = _cards[i]
		card.draw(ctx, _card_size)
	ctx.draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	#todo
	if _focused_card_id > -1:
		var card: Card = _cards[_focused_card_id]
		var box: Box = Box.new()
		box.init(card.position(), _card_size)
		box.set_hovered(true)
		ctx.draw_hovered(box)
