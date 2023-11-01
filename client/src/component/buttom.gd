extends Component
class_name Buttom

var texture: Texture = load("res://assets/error.png") as Texture
var text: String = "text"

func _init(
	ctx: Context,
	parent: Component,
	relative_type: int = 0,
	offset: Vector2 = Vector2.ZERO,
	custom_size: Vector2 = Vector2.ZERO
).(
	ctx,
	parent,
	relative_type,
	offset,
	custom_size
) -> void:
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
		ctx.canvas.draw_string(ctx.font, ctx.text_position(text), text)
		if mouse_hover():
			ctx.canvas.draw_rect(rect, ctx.clicked_color if mouse_click() else ctx.hover_color, false, ctx.hover_line_size)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
