extends Component
class_name Secrets

var list: List = List.new()
var texture: Texture = load("res://assets/error.png") as Texture

func _init() -> void:
	pass

func render(ctx: Context) -> void:
	input(ctx)
	if visible():
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		var rect: Rect2 = rect()
		ctx.canvas.draw_texture_rect(texture, rect, false)
		if mouse_hover():
			ctx.canvas.draw_rect(rect, ctx.clicked_color if mouse_click() else ctx.hover_color, false, ctx.hover_line_size)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
