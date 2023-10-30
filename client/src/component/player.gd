extends Component
class_name Player

var player_id: String
var is_this_player: bool
var hand: Hand
var tabel: Tabel
var factorys: Factorys
var secrets: Secrets
var graveyard: Graveyard
var deck: Deck
#var _data

func _init(
	is_client: bool,
	player_id: String,
	ctx: Context,
	parent: Component,
	relative_type: int = 0,
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = Vector2.ZERO
).(
	ctx,
	parent,
	relative_type,
	offset,
	custom_size
) -> void:
	var other_size := Vector2(200, 200) 
	var margin := 20.0
	player_id = player_id

	if is_client:
		is_this_player = true
		hand = Hand.new(true, ctx, self, Component.BottomHSplit)
		tabel = Tabel.new(ctx, self, Component.TopHSplit)
		factorys = Factorys.new(ctx, self, Component.BottomLeft, Vector2(20, 20), other_size)
		secrets = Secrets.new(ctx, self, Component.MarginRight, Vector2(10, 10), other_size)
		deck = Deck.new(ctx, self, Component.BottomRight, Vector2(20, 20), other_size)
		graveyard = Graveyard.new(ctx, self, Component.MarginLeft, Vector2(10, 10), other_size)
	else:
		is_this_player = false
		hand = Hand.new(false, ctx, self, Component.TopHSplit)
		tabel = Tabel.new(ctx, self, Component.BottomHSplit)
		factorys = Factorys.new(ctx, self, Component.TopRight, Vector2(20, 20), other_size)
		secrets = Secrets.new(ctx, self, Component.MarginLeft, Vector2(10, 10), other_size)
		deck = Deck.new(ctx, self, Component.TopLeft, Vector2(20, 20), other_size)
		graveyard = Graveyard.new(ctx, self, Component.MarginRight, Vector2(10, 10), other_size)
	
	var avatar: Card = Card.new(ctx)
	tabel.avatar_list.add_item(avatar)
	for i in range(3): 
		var card: Card = Card.new(ctx)
		tabel.left_list.add_item(card)
	for i in range(3): 
		var card: Card = Card.new(ctx)
		tabel.right_list.add_item(card)
	for i in range(7): 
		var card: Card = Card.new(ctx)
		hand.list.add_item(card)

#	for i in range(30): 
#		var card: Card = Card.new()
#		card.init()
#		deck.list.add_card(card)

func render(ctx: Context) -> void:
	factorys.render(ctx)
	secrets.render(ctx)
	graveyard.render(ctx)
	deck.render(ctx)
	tabel.render(ctx)
	hand.render(ctx)
