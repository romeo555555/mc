extends Object
class_name Setting

var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture

func draw(ctx: CanvasItem) -> void:
	ctx.draw_texture_rect(texture, box.rect(), false)
	ctx.draw_hovered(box)
