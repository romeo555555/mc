extends Object
class_name Player

var _rect: Rect2
var player_id: String
var hand: Hand = Hand.new()
var avatar: Avatar = Avatar.new()
var left_tabel: Line = Line.new()
var right_tabel: Line = Line.new()
var factorys: Factorys = Factorys.new()
var secrets: Secrets = Secrets.new()
var graveyard: Graveyard = Graveyard.new()
var deck: Deck = Deck.new()
#var _data

func _init(
	miroring: bool,
	player_id: String, 
	screen_size: Vector2, 
	texture: Texture = null, 
	arrow: Line2D = null, 
	margin_offset: Vector2 = Vector2.ZERO
):
	init(miroring, player_id, screen_size, texture, arrow, margin_offset)

func init(
	miroring: bool,
	player_id: String, 
	screen_size: Vector2, 
	texture: Texture = null, 
	arrow: Line2D = null, 
	margin_offset: Vector2 = Vector2.ZERO
):
	player_id = player_id

	var avatar_size := Vector2(200, 270) 
	var card_size := Vector2(200, 200) 
	var card_x_indent := 10.0
	var hadn_card_x_indent := -50.0
	var other_size := Vector2(200, 200) 
	var other_indent := Vector2(10, 0) 
	var linemargin := Vector2(20, 20) 
#	var avatar_card: Card = Card.new()
#	avatar_card.init()
	
	if miroring:
		_rect = Rect2(0.0, screen_size.y * 0.5, screen_size.x, screen_size.y * 0.5)
		var margin = Rect2(_rect.position + margin_offset, _rect.size - margin_offset * 2.0)
		var line_size := Vector2(_rect.size.x, _rect.size.y * 0.5)
		
#		tabel.init(Rect2(_rect.position, line_size), null, arrow, avatar, card_x_indent, linemargin)
		avatar.init(Vector2(_rect.position.x + (_rect.size.x - avatar_size.x) * 0.5, 
			_rect.position.y + (line_size.y - avatar_size.y) * 0.5), avatar_size)
		left_tabel.init_left(_rect.position, _rect.size * 0.5, card_size, card_x_indent)
		right_tabel.init_right(Vector2(_rect.position.x + _rect.size.x * 0.5, _rect.position.y),
			_rect.size * 0.5, card_size, card_x_indent)
		hand.init(_rect.position + Vector2(0.0, line_size.y), line_size, null, hadn_card_x_indent, linemargin)
		
		var other_pos := Vector2(margin.position.x, margin.end.y - other_size.y)
		factorys.init(other_pos, other_size)
		other_pos.x += other_indent.x + other_size.x
		secrets.init(other_pos, other_size)
		other_pos = margin.end - other_size
		deck.init(other_pos, other_size)
		other_pos.x -= other_indent.x + other_size.x
		graveyard.init(other_pos, other_size)
	else:
		_rect = Rect2(0.0, 0.0, screen_size.x, screen_size.y * 0.5)
		var margin = Rect2(_rect.position + margin_offset, _rect.size - margin_offset * 2.0)
		var line_size := Vector2(_rect.size.x, _rect.size.y * 0.5)
		
		avatar.init(Vector2(_rect.position.x + (_rect.size.x - avatar_size.x) * 0.5, 
			_rect.position.y + (line_size.y - avatar_size.y) * 0.5) + Vector2(0.0, line_size.y), avatar_size)
		left_tabel.init_left(_rect.position + Vector2(0.0, line_size.y), _rect.size * 0.5, card_size, card_x_indent)
		right_tabel.init_right(Vector2(_rect.position.x + _rect.size.x * 0.5, _rect.position.y) 
				+ Vector2(0.0, line_size.y), _rect.size * 0.5, card_size, card_x_indent)
		hand.init(_rect.position, line_size, null, hadn_card_x_indent, linemargin)
		
		var other_pos: Vector2 = margin.position
		deck.init(other_pos, other_size)
		other_pos.x += other_indent.x + other_size.x
		graveyard.init(other_pos, other_size)
		other_pos = Vector2(margin.end.x - other_size.x, margin.position.y)
		factorys.init(other_pos, other_size)
		other_pos.x -= other_indent.x + other_size.x
		secrets.init(other_pos, other_size)
		
	for i in range(2): 
		var card: Card = Card.new()
		card.init()
		left_tabel.add_card(card)
	for i in range(2): 
		var card: Card = Card.new()
		card.init()
		right_tabel.add_card(card)
	for i in range(7): 
		var card: Card = Card.new()
		card.init()
		hand.add_card(card)
	
	for i in range(30): 
		var card: Card = Card.new()
		card.init()
		deck.add_card(card)

func mouse_enter(sense: Sense) -> bool:
	if _rect.has_point(sense.mouse_pos()):
		if factorys.mouse_enter(sense):
			factorys.input(sense)
		elif secrets.mouse_enter(sense):
			secrets.input(sense)
		elif graveyard.mouse_enter(sense):
			graveyard.input(sense)
		elif deck.mouse_enter(sense):
			deck.input(sense)
		elif avatar.mouse_enter(sense):
			avatar.input(sense)
		elif hand.mouse_enter(sense):
			hand.input(sense)
		elif left_tabel.mouse_enter(sense):
			left_tabel.input(sense)
		elif right_tabel.mouse_enter(sense):
			right_tabel.input(sense)
		else:
			return false
		return true
	return false

func mouse_exit(sense: Sense) -> bool:
	if factorys.mouse_exit(sense):
		factorys.output(sense)
	elif secrets.mouse_exit(sense):
		secrets.output(sense)
	elif graveyard.mouse_exit(sense):
		graveyard.output(sense)
	elif deck.mouse_exit(sense):
		deck.output(sense)
	elif avatar.mouse_exit(sense):
		avatar.output(sense)
	elif hand.mouse_exit(sense):
		hand.output(sense)
	elif left_tabel.mouse_exit(sense):
		left_tabel.output(sense)
	elif right_tabel.mouse_exit(sense):
		right_tabel.output(sense)
	else:
		return false
	return true

func draw(ctx: CanvasItem):
#	if _texture:
#		ctx.draw_texture_rect(_texture, _rect, false)
	factorys.draw(ctx)
	secrets.draw(ctx)
	graveyard.draw(ctx)
	deck.draw(ctx)
	avatar.draw(ctx)
	left_tabel.draw(ctx)
	right_tabel.draw(ctx)
	hand.draw(ctx)
