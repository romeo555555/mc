extends Component
class_name ModalSetting

var texture: Texture = load("res://assets/error.png") as Texture
var buttom_play: Buttom 
var buttom_setting: Buttom
var buttom_exit: Buttom

func _init(
	buttom_margin: Vector2,
	buttom_size: Vector2,
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
	var pos := position() + buttom_margin
	buttom_play = Buttom.new(ctx, self, Component.CenterTop, buttom_margin + (buttom_margin + buttom_size) * 0, buttom_size)
	buttom_play.text = "Play"
	buttom_setting = Buttom.new(ctx, self, Component.CenterTop, buttom_margin + (buttom_margin + buttom_size) * 1, buttom_size)
	buttom_setting.text = "Setting"
	buttom_exit = Buttom.new(ctx, self, Component.CenterTop, buttom_margin + (buttom_margin + buttom_size) * 2, buttom_size)
	buttom_exit.text = "Exit"

func render(ctx: Context) -> void:
#	input(ctx)
	if visible():
		ctx.draw_shadowing()
		ctx.canvas.draw_set_transform(center(), rotation(), scale())
		var rect: Rect2 = rect()
#		ctx.canvas.draw_texture_rect(texture, rect, false)
		ctx.canvas.draw_rect(rect, Color.brown)
#		if mouse_hover():
#			ctx.canvas.draw_rect(rect, ctx.clicked_color if mouse_click() else ctx.hover_color, false, ctx.hover_line_size)
		#func drawbuttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
		buttom_play.render(ctx)
		buttom_setting.render(ctx)
		buttom_exit.render(ctx)
		ctx.canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
