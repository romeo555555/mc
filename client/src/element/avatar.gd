extends Object
class_name Avatar

var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture
#var screen: Screen


func draw(ctx: CanvasItem) -> void:
	ctx.draw_texture_rect(texture, box.rect(), false)
	ctx.draw_hovered(box)
