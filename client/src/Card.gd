extends Sprite

var card_size: Vector2

var padding: Vector2


var card_name: String
var healty
var attack
var ability
var desc: String
var color #CardColor #int
var cost #CardCost
var type #CardType


func _ready():
	var builder = get_parent().card_builder
	pass
