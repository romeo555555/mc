extends Component
class_name Player

var player_id: String
var is_this_player := false
var hand: Hand = Hand.new()
var tabel: Tabel = Tabel.new()
var factorys: Factorys = Factorys.new()
var secrets: Secrets = Secrets.new()
var graveyard: Graveyard = Graveyard.new()
var deck: Deck = Deck.new()
#var _data

#func init(
#	is_client: bool,
#	player_id: String
##	margin_offset: Vector2 = Vector2.ZERO
#) -> void:
#	player_id = player_id
#	var other_size := Vector2(200, 200) 
#	var avatar_size := Vector2(200, 200) 
#	var margin := 20.0
#
#	if is_client:
#		is_this_player = is_client
#		hand.box.set_rect(box.relative_rect(Box.BottomHSplit))
#		hand.list.set_rect(hand.box.relative_rect(Box.Padding, 20))
#		hand.list.set_card_size(1, -50.0)
#		hand.list.set_capacity(10)
#		hand.list.set_aligment(List.Aligment.Bent)
#		hand.list.set_miroring(true)
#
#		tabel.box.set_rect(box.relative_rect(Box.TopHSplit))
#		tabel.left_list.set_rect(tabel.box.relative_rect(Box.LeftVSplit, 20))
#		tabel.left_list.set_card_size(1, 10.0)
#		tabel.left_list.set_capacity(4)
#		tabel.left_list.set_aligment(List.Aligment.Right)
#		tabel.right_list.set_rect(tabel.box.relative_rect(Box.RightVSplit, 20))
#		tabel.right_list.set_card_size(1, 10.0)
#		tabel.right_list.set_capacity(4)
#		tabel.right_list.set_aligment(List.Aligment.Left)
#		tabel.avatar_list.set_rect(tabel.box.relative_rect(Box.Center, 0, avatar_size))
#		tabel.avatar_list.set_card_size(1, 0.0)
#		tabel.avatar_list.set_capacity(1)
#		tabel.avatar_list.set_aligment(List.Aligment.Center)
#
#		factorys.box.set_rect(box.relative_rect(Box.BottomLeft, 20, other_size))
#		secrets.box.set_rect(factorys.box.relative_rect(Box.MarginRight, 10, other_size))
#		deck.box.set_rect(box.relative_rect(Box.BottomRight, 20, other_size))
#		graveyard.box.set_rect(deck.box.relative_rect(Box.MarginLeft, 10, other_size))
#	else:
#		hand.box.set_rect(box.relative_rect(Box.TopHSplit))
#		hand.list.set_rect(hand.box.relative_rect(Box.Padding, 20))
#		hand.list.set_card_size(1, -50.0)
#		hand.list.set_capacity(10)
#		hand.list.set_aligment(List.Aligment.Bent)
#
#		tabel.box.set_rect(box.relative_rect(Box.BottomHSplit))
#		tabel.left_list.set_rect(tabel.box.relative_rect(Box.LeftVSplit, 20))
#		tabel.left_list.set_card_size(1, 10.0)
#		tabel.left_list.set_capacity(4)
#		tabel.left_list.set_aligment(List.Aligment.Right)
#		tabel.right_list.set_rect(tabel.box.relative_rect(Box.RightVSplit, 20))
#		tabel.right_list.set_card_size(1, 10.0)
#		tabel.right_list.set_capacity(4)
#		tabel.right_list.set_aligment(List.Aligment.Left)
#		tabel.avatar_list.set_rect(tabel.box.relative_rect(Box.Center, 0, avatar_size))
#		tabel.avatar_list.set_card_size(1, 0.0)
#		tabel.avatar_list.set_capacity(1)
#		tabel.avatar_list.set_aligment(List.Aligment.Center)
#
#		factorys.box.set_rect(box.relative_rect(Box.TopRight, 20, other_size))
#		secrets.box.set_rect(factorys.box.relative_rect(Box.MarginLeft, 10, other_size))
#		deck.box.set_rect(box.relative_rect(Box.TopLeft, 20, other_size))
#		graveyard.box.set_rect(deck.box.relative_rect(Box.MarginRight, 10, other_size))
#
#	var avatar: Card = Card.new()
#	avatar.init()
#	tabel.avatar_list.add_card(avatar)
#	for i in range(3): 
#		var card: Card = Card.new()
#		card.init()
#		tabel.left_list.add_card(card)
#	for i in range(3): 
#		var card: Card = Card.new()
#		card.init()
#		tabel.right_list.add_card(card)
#	for i in range(7): 
#		var card: Card = Card.new()
#		card.init()
#		hand.list.add_card(card)
#
##	for i in range(30): 
##		var card: Card = Card.new()
##		card.init()
##		deck.list.add_card(card)

func draw(ctx: Context) -> void:
#	if _texture:
#		ctx.draw_texture_rect(_texture, _rect, false)
	factorys.draw(ctx)
	secrets.draw(ctx)
	graveyard.draw(ctx)
	deck.draw(ctx)
	tabel.draw(ctx)
	hand.draw(ctx)
