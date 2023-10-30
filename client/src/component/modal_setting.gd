extends Component
class_name ModalSetting

var texture: Texture = load("res://assets/error.png") as Texture
var buttom_play: Buttom 
var buttom_setting: Buttom
var buttom_exit: Buttom

func _init(
	y_indent: float,
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
#	var _margin := box.relative_rect(Box.Padding, padding)
#	var buttom_count := 3
#	var buttom_size := Vector2(_margin.size.x, _margin.size.y / buttom_count - y_indent)
#	var buttom_pos := _margin.position
#	buttom_play = Buttom.new()
#	buttom_play.box.set_rect(Rect2(buttom_pos, buttom_size))
#	buttom_play.text = "Play"
#	buttom_setting.box.set_rect(buttom_play.box.relative_rect(Box.MarginBottom, y_indent, buttom_size))
#	buttom_setting.text = "Setting"
#	buttom_exit.box.set_rect(buttom_setting.box.relative_rect(Box.MarginBottom, y_indent, buttom_size))
#	buttom_exit.text = "Exit"

func render(ctx: Context) -> void:
	input(ctx)
	if visible():
		ctx.draw_shadowing()
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		var rect: Rect2 = rect()
#		ctx.canvas.draw_texture_rect(texture, rect, false)
		ctx.canvas.draw_rect(rect(), Color.brown)
		if mouse_hover():
			ctx.canvas.draw_rect(rect, ctx.clicked_color if mouse_click() else ctx.hover_color, false, ctx.hover_line_size)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
	#func drawbuttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
#	buttom_play.render(ctx)
#	buttom_setting.render(ctx)
#	buttom_exit.render(ctx)
