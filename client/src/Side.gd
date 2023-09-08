extends Control
export(bool) var _miroring := false

func _ready():
	pass

func hand() -> Node:
	return get_child(0)

func avatar() -> Node:
	return get_child(1)

func tabel() -> Node:
	return get_child(2)

func builds() -> Node:
	return get_child(3)

func deck() -> Node:
	return get_child(4)

func dead() -> Node:
	return get_child(5)

func traps() -> Node:
	return get_child(6)
