extends Object
class_name ModalSetting

var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture
var buttom_play: Buttom = Buttom.new() 
var buttom_setting: Buttom = Buttom.new()
var buttom_exit: Buttom = Buttom.new()

func init(screen_size: Vector2, size: Vector2, padding: float, y_indent: float = 10) -> void:
	box.set_rect(Rect2((screen_size - size) * 0.5, size))
	var _margin := box.relative_rect(Box.Padding, padding)
	var buttom_count := 3
	var buttom_size := Vector2(_margin.size.x, _margin.size.y / buttom_count - y_indent)
	var buttom_pos := _margin.position
	buttom_play.box.set_rect(Rect2(buttom_pos, buttom_size))
	buttom_play.text = "Play"
	buttom_setting.box.set_rect(buttom_play.box.relative_rect(Box.MarginBottom, y_indent, buttom_size))
	buttom_setting.text = "Setting"
	buttom_exit.box.set_rect(buttom_setting.box.relative_rect(Box.MarginBottom, y_indent, buttom_size))
	buttom_exit.text = "Exit"

func draw(ctx: CanvasItem) -> void:
	#func drawbuttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
	ctx.draw_shadowing()
	ctx.draw_rect(box.rect(), Color.brown)
	buttom_play.draw(ctx)
	buttom_setting.draw(ctx)
	buttom_exit.draw(ctx)
