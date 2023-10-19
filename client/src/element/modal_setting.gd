extends Object
class_name ModalSetting

var box: Box = Box.new()
var _texture: Texture
var _margin: Rect2
var _y_indent: float
var _buttom_play: Buttom = Buttom.new() 
var _buttom_setting: Buttom = Buttom.new()
var _buttom_exit: Buttom = Buttom.new()

func init(screen_size: Vector2, size: Vector2, margin_offset: Vector2, y_indent: float = 10, texture: Texture = load("res://assets/error.png") as Texture) -> void:
	box.init((screen_size - size) * 0.5, size)
	_margin = Rect2(box.rect().position + margin_offset, size - margin_offset * 2)
	_y_indent = y_indent
	_texture = texture
	var buttom_count := 3
	var buttom_size := Vector2(_margin.size.x, _margin.size.y / buttom_count - _y_indent)
	var buttom_pos := _margin.position
	var y_offset := buttom_size.y + _y_indent
	_buttom_play.init(buttom_pos, buttom_size, "Play")
	buttom_pos.y += y_offset
	_buttom_setting.init(buttom_pos, buttom_size, "Setting")
	buttom_pos.y += y_offset
	_buttom_exit.init(buttom_pos, buttom_size, "Exit")


func input(sense: Sense) -> void:
#	box.set_hovered(true)
#	if box.is_clicked():
#		sense.send_action(Sense.ScreenSetting)
	match _buttom_play.box.input(sense):
		0: _buttom_play.output(sense)
		1: _buttom_play.input(sense)
#		2: 
#			_buttom_play.input(sense)
#			_buttom_play.clicked(sense)
		_: pass
	match _buttom_setting.box.input(sense):
		0: _buttom_setting.output(sense)
		1: _buttom_setting.input(sense)
		_: pass
	match _buttom_exit.box.input(sense):
		0: _buttom_exit.output(sense)
		1: _buttom_exit.input(sense)
		_: pass
	pass
func output(sense: Sense) -> void:
	pass
#	box.set_hovered(false)

func draw(ctx: CanvasItem) -> void:
	#func draw_buttom_setting_menu(ctx: CanvasItem, font_size: int, rect: Rect2, margin: Rect2, indent: float):
	ctx.draw_shadowing()
	ctx.draw_rect(box.rect(), Color.brown)
	_buttom_play.draw(ctx)
	_buttom_setting.draw(ctx)
	_buttom_exit.draw(ctx)
