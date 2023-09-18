tool
extends Control

export(bool) var tabel_draw := true
var card: Card = Card.new()
var tabel: Tabel = Tabel.new()
var hand: Hand = Hand.new()

func _ready():
	card.setup()
#	hand.setup()
#	tabel.setup()
	card.set_position(Vector2(300, 300))
func _process(delta):
	update()

func _draw():
	if tabel_draw:
		tabel.cast_right(card)
		tabel.draw(self)
	else:
		hand.add_card(card)
		hand.draw(self)
