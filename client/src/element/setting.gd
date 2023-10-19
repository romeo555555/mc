extends Object
class_name Setting

var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture

var screen_size := Vector2(1980, 1080)
var font = DynamicFont.new()
var font_size: int = 42
var clicked_color := Color.red
var hover_color := Color.aliceblue
var hover_line_size := 15
#var font = get_font("font")

func draw(ctx: CanvasItem) -> void:
	ctx.draw_texture_rect(texture, box.rect(), false)
	ctx.draw_hovered(box)
