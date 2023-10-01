extends Component
class_name Player

var player_id: String
var hand: Hand = Hand.new()
var tabel: Tabel = Tabel.new()
var factorys: Factorys = Factorys.new()
var secrets: Secrets = Secrets.new()
var graveyard: Graveyard = Graveyard.new()
var deck: Deck = Deck.new()

var _margin: Rect2
#var _data

func _init(
	miroring: bool,
	player_id: String, 
	screen_size: Vector2, 
	texture: Texture = null, 
	arrow: Line2D = null, 
	margin_offset: Vector2 = Vector2.ZERO
):
	new(miroring, player_id, screen_size, texture, arrow, margin_offset)

func new(
	miroring: bool,
	player_id: String, 
	screen_size: Vector2, 
	texture: Texture = null, 
	arrow: Line2D = null, 
	margin_offset: Vector2 = Vector2.ZERO
):
	player_id = player_id

	var avatar_size := Vector2(200, 270) 
	var other_size := Vector2(200, 200) 
	var other_indent := Vector2(10, 0) 
	var card_x_indent := 10.0
	var hadn_card_x_indent := -50.0
	var line_margin := Vector2(20, 20) 
#	var line_margin := Vector2(10, 10) 
	var avatar: Card = Card.new()
	avatar.setup()
	
	if miroring:
		_rect = Rect2(0.0, screen_size.y * 0.5, screen_size.x, screen_size.y * 0.5)
		_margin = Rect2(_rect.position + margin_offset, _rect.size - margin_offset * 2.0)
		var line_size := Vector2(_rect.size.x, _rect.size.y * 0.5)
			
		tabel.setup(Rect2(_rect.position, line_size), null, arrow, avatar, card_x_indent, line_margin)
		hand.setup(Rect2(tabel.position() + Vector2(0.0, line_size.y), line_size), null, hadn_card_x_indent, line_margin)
		var other_pos := Vector2(_margin.position.x, _margin.end.y - other_size.y)
		factorys.setup(Rect2(other_pos, other_size))
		other_pos.x += other_indent.x + other_size.x
		secrets.setup(Rect2(other_pos, other_size))
		other_pos = _margin.end - other_size
		deck.setup(Rect2(other_pos, other_size))
		other_pos.x -= other_indent.x + other_size.x
		graveyard.setup(Rect2(other_pos, other_size))
	else:
		_rect = Rect2(0.0, 0.0, screen_size.x, screen_size.y * 0.5)
		_margin = Rect2(_rect.position + margin_offset, _rect.size - margin_offset * 2.0)
		var line_size := Vector2(_rect.size.x, _rect.size.y * 0.5)
		
		hand.setup(Rect2(_rect.position, line_size), null, hadn_card_x_indent, line_margin)
		tabel.setup(Rect2(hand.position() + Vector2(0.0, line_size.y), line_size), null, arrow, avatar, card_x_indent, line_margin)
		var other_pos := _margin.position
		deck.setup(Rect2(other_pos, other_size))
		other_pos.x += other_indent.x + other_size.x
		graveyard.setup(Rect2(other_pos, other_size))
		other_pos = Vector2(_margin.end.x - other_size.x, _margin.position.y)
		factorys.setup(Rect2(other_pos, other_size))
		other_pos.x -= other_indent.x + other_size.x
		secrets.setup(Rect2(other_pos, other_size))
		
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		tabel.left_line.add_card(card)
	for i in range(2): 
		var card: Card = Card.new()
		card.setup()
		tabel.right_line.add_card(card)
	for i in range(7): 
		var card: Card = Card.new()
		card.setup()
		hand.add_card(card)
	
	for i in range(30): 
		var card: Card = Card.new()
		card.setup()
		deck.add_card(card)

func mouse_enter(sense: Sense) -> bool:
	if _rect.has_point(sense.mouse_pos()):
		sense.set_player_id(player_id)
		if factorys.mouse_enter(sense):
			factorys.input(sense)
		elif secrets.mouse_enter(sense):
			secrets.input(sense)
		elif graveyard.mouse_enter(sense):
			graveyard.input(sense)
		elif deck.mouse_enter(sense):
			deck.input(sense)
		elif hand.mouse_enter(sense):
			hand.input(sense)
		elif tabel.mouse_enter(sense):
			tabel.input(sense)
		return true
	return false

func _mouse_enter(sense: Sense) -> bool:
	if _rect.has_point(sense.mouse_pos()):
		if factorys._mouse_enter(sense):
			sense.set_view_id(Sense.Factorys)
		elif secrets._mouse_enter(sense):
			sense.set_view_id(Sense.Secrets)
		elif graveyard._mouse_enter(sense):
			sense.set_view_id(Sense.Graveyard)
		elif deck._mouse_enter(sense):
			sense.set_view_id(Sense.Deck)
		elif hand._mouse_enter(sense):
			sense.set_view_id(Sense.Hand)
		elif tabel._mouse_enter(sense):
			pass
		else:
			sense.set_view_id(Sense.None)
		return true
	return false

func draw(ctx: CanvasItem):
#	if _texture:
#		ctx.draw_texture_rect(_texture, _rect, false)
	factorys.draw(ctx)
	secrets.draw(ctx)
	graveyard.draw(ctx)
	deck.draw(ctx)
	tabel.draw(ctx)
	hand.draw(ctx)
