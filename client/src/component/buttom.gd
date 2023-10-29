extends Component
class_name Buttom

var texture: Texture = load("res://assets/error.png") as Texture
var text: String = "text"

func _init() -> void:
	pass

func render(ctx: Context) -> void:
	input(ctx)
	if visible():
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		var rect: Rect2 = rect()
#		ctx.canvas.draw_texture_rect(texture, rect, false)
#		if highlight():
#			ctx.canvas.draw_rect(Rect2(Vector2.ZERO - card_pivot, card_size), highlight_color(), false, 15)
		
#		ctx.draw_texture_rect(texture, rect, false)
		ctx.canvas.draw_rect(rect, Color.violet)
#		ctx.font.set_size(FONT_SIZE)
		var h_font_size = ctx.font_size * 0.5
		ctx.canvas.draw_string(ctx.font, center() - ctx.font.get_string_size(text) * 0.5 + Vector2(0, h_font_size), text)
		if mouse_hover():
			ctx.canvas.draw_rect(rect, ctx.clicked_color if mouse_click() else ctx.hover_color, false, ctx.hover_line_size)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
