extends Object
class_name Board

var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture

func draw(ctx: CanvasItem) -> void:
	ctx.draw_texture_rect(texture, box.rect(), false)
#	if _sense_rect.focused:
		#hovered ctx.hovered_color
	pass
