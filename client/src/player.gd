extends Object
class_name Player

var hand: Hand = Hand.new()
var tabel: Tabel = Tabel.new()
var factorys: Factorys = Factorys.new()
var secrets: Secrets = Secrets.new()
var graveyard: Graveyard = Graveyard.new()
var deck: Deck = Deck.new()

var _texture: Texture
var _margin: Rect2
var _rect: Rect2
#var _data

func setup(rect: Rect2, margin_offset: Vector2 = Vector2.ZERO, miroring: bool = false, texture: Texture = null):
	_texture = texture
	_margin = Rect2(rect.position + margin_offset, rect.size - margin_offset * 2.0)
	_rect = rect
	
	var line_size := Vector2(rect.size.x, rect.size.y * 0.5)
	var avatar_size := Vector2(200, 270) 
	var other_size := Vector2(200, 200) 
	var other_indent := Vector2(10, 0) 
	var card_x_indent := 10.0
	var line_margin := Vector2(10, 10) 
	
	
	if miroring:
		tabel.setup(Rect2(rect.position, line_size), card_x_indent, line_margin)
		hand.setup(Rect2(tabel.position() + Vector2(0.0, line_size.y), line_size), card_x_indent, line_margin)
		var other_pos := Vector2(_margin.position.x, _margin.end.y - other_size.y)
		factorys.setup(Rect2(other_pos, other_size))
		other_pos.x += other_indent.x + other_size.x
		secrets.setup(Rect2(other_pos, other_size))
		other_pos = _margin.end - other_size
		deck.setup(Rect2(other_pos, other_size))
		other_pos.x -= other_indent.x + other_size.x
		graveyard.setup(Rect2(other_pos, other_size))
	else:
		hand.setup(Rect2(rect.position, line_size), card_x_indent, line_margin)
		tabel.setup(Rect2(hand.position() + Vector2(0.0, line_size.y), line_size), card_x_indent, line_margin)
		var other_pos := _margin.position
		deck.setup(Rect2(other_pos, other_size))
		other_pos.x += other_indent.x + other_size.x
		graveyard.setup(Rect2(other_pos, other_size))
		other_pos = Vector2(_margin.end.x - other_size.x, _margin.position.y)
		factorys.setup(Rect2(other_pos, other_size))
		other_pos.x -= other_indent.x + other_size.x
		secrets.setup(Rect2(other_pos, other_size))

func set_position(pos: Vector2):
	_rect.position = pos

func position() -> Vector2:
	return _rect.position

func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)

func draw(ctx: CanvasItem):
	if _texture:
		ctx.draw_texture_rect(_texture, _rect, false)
	factorys.draw(ctx)
	secrets.draw(ctx)
	graveyard.draw(ctx)
	deck.draw(ctx)
	tabel.draw(ctx)
	hand.draw(ctx)
