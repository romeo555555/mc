extends Object
class_name Deck

var box: Box = Box.new()
var list: List = List.new()
var texture: Texture = load("res://assets/error.png") as Texture

func draw(ctx: CanvasItem) -> void:
	
#	match box.containe(sense):
#	match input(sense):
##		Sense.Enter:
##		Sense.Exit:
#		Sense.Click:
	
#	if _texture:
	ctx.draw_texture_rect(texture, box.rect(), false)
	ctx.draw_hovered(box)

#func remove_card(card: Control) -> void:
#	var _last_colum_count = card_count() % _max_row_count
#	print("colum", _last_colum_count)
#	if _last_colum_count == 0:
#		_row_count += 1
#	var pos := _card_indent + (_card_size + _card_indent) \
#	 * Vector2(_last_colum_count, _row_count) 
#	add_child(card)
#	card.set_position(pos)

#func card_count() -> int:
#	return get_child_count()

#func aligment() -> void:
#	var count := card_count()
#	var offset := _card_size.x + _card_indent.x
#	var start_x := (count * offset - _card_indent.x) * -1
#	var x := (rect_size.x + start_x) * 0.5
#	for i in range(2, count):
#		get_child(i).set_position(Vector2(x, 0))
#		x += offset
