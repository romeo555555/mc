extends Object
class_name New

var _sense_rect: SenseRect
var _texture: Texture

func _init():
	new()

func new():
	pass

func mouse_enter(sense: Sense) -> bool:
	return _sense_rect.mouse_enter(sense)

func mouse_exit(sense: Sense) -> bool:
	return _sense_rect.mouse_exit(sense)

func input(sense: Sense):
	pass

func output(sense: Sense):
	pass

func draw(ctx: CanvasItem):
#	if _sense_rect.focused:
		#hovered ctx.hovered_color
	pass
