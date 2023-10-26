extends Object
class_name Buttom

var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture
var text: String

func draw(ctx: CanvasItem) -> void: #, texture: Texture = load("res://assets/error.png") as Texture):
	var config: Config = ctx.config
#	ctx.draw_texture_rect(texture, rect, false)
	ctx.draw_rect(box.rect(), Color.violet)
#	ctx.font.set_size(FONT_SIZE)
	var h_font_size = config.font_size * 0.5
	ctx.draw_string(config.font, box.rect().get_center() - config.font.get_string_size(text) * 0.5 + Vector2(0, h_font_size), text)
	ctx.draw_hovered(box)
