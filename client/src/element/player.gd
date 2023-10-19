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
) -> void:
	init(miroring, player_id, screen_size, texture, arrow, margin_offset)

func init(
	miroring: bool,
	player_id: String, 
	screen_size: Vector2, 
	texture: Texture = null, 
	arrow: Line2D = null, 
	margin_offset: Vector2 = Vector2.ZERO
) -> void:
	player_id = player_id

	var avatar_size := Vector2(200, 270) 
	var card_size := Vector2(200, 200) 
	var card_x_indent := 10.0
	var hadn_card_x_indent := -50.0
	var other_size := Vector2(200, 200) 
	var other_indent := Vector2(10, 0) 
	var startoffset := Vector2(20, 20) 
#	var avatar_card: Card = Card.new()
#	avatar_card.init()
	
	if miroring:
		_rect = Rect2(0.0, screen_size.y * 0.5, screen_size.x, screen_size.y * 0.5)
		var margin = Rect2(_rect.position + margin_offset, _rect.size - margin_offset * 2.0)
		var line_size := Vector2(_rect.size.x, _rect.size.y * 0.5)
		
#		tabel.init(Rect2(_rect.position, line_size), null, arrow, avatar, card_x_indent, startoffset)
		avatar.init(Vector2(_rect.position.x + (_rect.size.x - avatar_size.x) * 0.5, 
			_rect.position.y + (line_size.y - avatar_size.y) * 0.5), avatar_size)
		left_tabel.init_left(true, _rect.position, _rect.size * 0.5, card_size, card_x_indent)
		right_tabel.init_right(true, Vector2(_rect.position.x + _rect.size.x * 0.5, _rect.position.y),
			_rect.size * 0.5, card_size, card_x_indent)
		hand.init(true, _rect.position + Vector2(0.0, line_size.y), line_size, null, 
			card_size, hadn_card_x_indent, startoffset)
		
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
		left_tabel.init_left(false, _rect.position + Vector2(0.0, line_size.y), _rect.size * 0.5, card_size, card_x_indent)
		right_tabel.init_right(false, Vector2(_rect.position.x + _rect.size.x * 0.5, _rect.position.y) 
				+ Vector2(0.0, line_size.y), _rect.size * 0.5, card_size, card_x_indent)
		hand.init(false, _rect.position, line_size, null, 
			card_size, hadn_card_x_indent, startoffset)
		
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

func input(sense: Sense) -> void:
	if _rect.has_point(sense.mouse_pos()):
		sense.set_player_id(player_id)
	match factorys.box.input(sense):
		Sense.Enter: 
			factorys.box.set_hovered(true)
		Sense.Exit: 
			factorys.box.set_hovered(false)
		Sense.Click: 
			sense.send_action(Sense.EndTurn)
		_: pass
	match secrets.box.input(sense):
		Sense.Enter: secrets.mouse_enter(sense)
		Sense.Exit: secrets.mouse_exit(sense)
		Sense.Click: secrets.mouse_click(sense)
		_: pass
	match graveyard.box.input(sense):
		Sense.Enter: graveyard.mouse_enter(sense)
		Sense.Exit: graveyard.mouse_exit(sense)
		Sense.Click: graveyard.mouse_click(sense)
		_: pass
	match deck.box.input(sense):
		Sense.Enter: deck.mouse_enter(sense)
		Sense.Exit: deck.mouse_exit(sense)
		Sense.Click: deck.mouse_click(sense)
		_: pass
	match avatar.box.input(sense):
		Sense.Enter: avatar.mouse_enter(sense)
		Sense.Exit: avatar.mouse_exit(sense)
		Sense.Click: avatar.mouse_click(sense)
		_: pass
	match hand.box.input(sense):
		Sense.Enter: hand.mouse_enter(sense)
		Sense.Exit: hand.mouse_exit(sense)
		Sense.Click: hand.mouse_click(sense)
		_: pass
	match left_tabel.box.input(sense):
		Sense.Enter: left_tabel.mouse_enter(sense)
		Sense.Exit: left_tabel.mouse_exit(sense)
		Sense.Click: left_tabel.mouse_click(sense)
		_: pass
	match right_tabel.box.input(sense):
		Sense.Enter: right_tabel.mouse_enter(sense)
		Sense.Exit: right_tabel.mouse_exit(sense)
		Sense.Click: right_tabel.mouse_click(sense)
		_: pass

func draw(ctx: CanvasItem) -> void:
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
