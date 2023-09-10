#tool
extends Control
export(bool) var _miroring := false
onready var parent: Node = get_parent().get_parent()
onready var hand: Node = $Hand
onready var avatar: Node = $Avatar
onready var tabel: Node = $Tabel
onready var builds: Node = $Builds
onready var traps: Node = $Traps
onready var dead: Node = $Dead
onready var deck: Node = $Deck

onready var rect_avatar: Rect2 = avatar.get_rect()
onready var rect_builds: Rect2 = builds.get_rect()
onready var rect_traps: Rect2 = traps.get_rect()
onready var rect_dead: Rect2 = dead.get_rect()
onready var rect_deck: Rect2 = deck.get_rect()

#onready var hand: Node = $Hand
#onready var avatar: Node = $Avatar
#onready var tabel: Node = $Tabel
onready var avatar_id: int = parent.ComponentID.AVATAR
onready var builds_id: int = parent.ComponentID.BUILDS
onready var traps_id: int = parent.ComponentID.TRAPS
onready var dead_id: int = parent.ComponentID.DEAD
onready var deck_id: int = parent.ComponentID.DECK
var player_id: int

func _ready():
	var parent: Node = get_parent().get_parent()
	builds_id = parent.ComponentID.BUILDS
	traps_id = parent.ComponentID.TRAPS
	dead_id = parent.ComponentID.DEAD
	deck_id = parent.ComponentID.DECK
	
	if _miroring:
		var tabel_pos: Vector2 = tabel.get_rect().position
		var avatar_pos: Vector2 = avatar.get_rect().position
		var hand_pos: Vector2 = hand.get_rect().position
		var builds_pos: Vector2 = builds.get_rect().position
		var traps_pos: Vector2 = traps.get_rect().position
		var dead_pos: Vector2 = dead.get_rect().position
		var deck_pos: Vector2 = deck.get_rect().position
		var offset_y: float = get_end().y - traps.get_end().y
		hand.set_position(tabel_pos)
		tabel.set_position(hand_pos)
		avatar.set_position(Vector2(avatar_pos.x, hand_pos.y + offset_y))
		deck.set_position(Vector2(builds_pos.x, tabel_pos.y + offset_y))
		builds.set_position(Vector2(deck_pos.x, tabel_pos.y + offset_y))
		traps.set_position(Vector2(dead_pos.x, tabel_pos.y + offset_y))
		dead.set_position(Vector2(traps_pos.x, tabel_pos.y + offset_y))
#	for i in range(100):
#		var card = card_prefab.instance()
#		add_child(card)
	for i in range(100):
		var t: Texture = load("res://assets/av1.png")
		textures.append(t)
	font = DynamicFont.new()
	font.font_data = load("res://assets/font/SansSerif.ttf")
	font.size = 300

var font: Font
var textures:Array
func _process(delta):
	update()

func _draw():
	var p:=10.0
	for t in textures:
		draw_rect(Rect2(p, 0, 300, 300), Color.aqua)
#		draw_texture_rect(t, Rect2(p, 0, 300, 300), false)
		draw_string(font, Vector2(p, 300), "Hellow world!")
		p += p
	pass
#const card_prefab: PackedScene = preload("res://src/Card.tscn")
func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		if rect_avatar.has_point(mouse_pos):
			pass
		elif rect_builds.has_point(mouse_pos):
			parent.callback_builds()
		elif rect_deck.has_point(mouse_pos):
			parent.callback_deck()
		elif rect_dead.has_point(mouse_pos):
			parent.callback_dead()
		elif rect_traps.has_point(mouse_pos):
			parent.callback_traps()

func get_line(line_id: int) -> Node:
	if line_id == 1:
		return tabel
	if line_id == 2:
		return hand
	return null

func callback_avatar():
	parent.callback_avatar()

func callback_tabel():
	parent.callback_tabel()

func callback_tabel_card(line_id: int, card_id: int):
	parent.callback_tabel_card(player_id, line_id, card_id)

func callback_hand():
	parent.callback_hand()

func callback_hand_card():
	parent.callback_hand_card()
