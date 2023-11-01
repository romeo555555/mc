extends Component
class_name Board

enum Screen { 
	Board, 
	Setting, 
	Deck, 
	Factorys, 
	Graveyard, 
	Secrets, 
	Card, 
	TabelCard, 
	Attack,
#	Cast, 
#	Attack, 
#	ShiftinHand,
	EndTurn
}
var active_screen: int = Screen.Board
enum MatchType { OneVsOne, TwoVsTwo }
var match_type: int = 0
var texture: Texture = load("res://assets/error.png") as Texture
var end: End
#var players: Dictionary = {}
var client_player1: Player
var opp_player1: Player
var client_player2: Player
var opp_player2: Player

var setting: Setting
var modal_setting: ModalSetting
#var modal_attack = ModalAttack.new()
#var modal_card_on_tabel = ModalCardOnTabel.new()
var modal_card: ModalCard
var modal_choose_card: ModalChooseCard
var modal_scroll_list: ModalScrollList

func _init(root: Node, ctx: Context).(
	ctx,
	self, 
	Component.TopLeft, 
	Vector2.ZERO, 
	ctx.screen_size
) -> void:
	set_pivot(Vector2.ZERO)
	texture = load("res://assets/board1.png") as Texture
#	box.set_rect(Rect2(Vector2.ZERO, config.screen_size))
#	end = End.new(ctx, self)
	modal_scroll_list = ModalScrollList.new(ctx, self, Component.Center, Vector2.ZERO, Vector2(900, 900))
	modal_scroll_list.set_visible(false)
	modal_scroll_list.component.set_visible(false)
	root.add_child(modal_scroll_list)
	for i in range(30): 
		var card: Card = Card.new(ctx)
		modal_scroll_list.list.add_item(card)
	modal_card = ModalCard.new(ctx, self, Component.CenterLeft, Vector2(150, 150), Vector2(400, 400))
	modal_card.card = Card.new(ctx)
#	modal_card.set_position(modal_card.position() + Vector2(0, modal_card.size().y * 0.35))
	modal_choose_card = ModalChooseCard.new(ctx, self, Component.Center, Vector2.ZERO, Vector2(900, 300))
	setting = Setting.new(ctx, self, Component.TopLeft, Vector2(30,30), Vector2(100, 100))
	modal_setting = ModalSetting.new(Vector2(0, 20), Vector2(450, 170), ctx, self, Component.Center, Vector2.ZERO, Vector2(600, 600))
	opp_player1 = Player.new(false, "Opp", ctx, self, Component.TopHSplit)
	client_player1 = Player.new(true, "Client", ctx, self, Component.BottomHSplit)
#	match_type = MatchType.OneVsOne

func draw_dragging(ctx: Context, mouse_pos: Vector2) -> void:
	client_player1.hand.draw_cached_card(ctx, mouse_pos)

func render(ctx: Context) -> void:
	ctx.canvas.draw_texture_rect(texture, rect(), false)
	#	end.draw(self)
	opp_player1.render(ctx)
	client_player1.render(ctx)
#	match match_type:
#		MatchType.OneVsOne:
#			opp_player1.draw(ctx)
#			client_player1.draw(ctx)
#		MatchType.TwoVsTwo:
#			opp_player2.draw(ctx)
#			client_player2.draw(ctx)
#			opp_player1.draw(ctx)
#			client_player1.draw(ctx)
#
	setting.render(ctx)
#
#	modal_card.render(ctx)
#	ctx.draw_shadowing()
#	modal_scroll_list.render(ctx)
#	modal_choose_card.render(ctx)
#	if setting.modal:
#		modal_setting.render(ctx)
	
#	match active_screen:
#		Screen.Setting:
#			modal_setting.draw(ctx)
#		Screen.Deck: 
#			modal_scroll_list.draw(ctx)
#		Screen.Factorys:
#			modal_scroll_list.draw(ctx)
#		Screen.Graveyard: 
#			modal_scroll_list.draw(ctx)
#		Screen.Secrets:
#			modal_scroll_list.draw(ctx)
#		Screen.Card:
#			modal_card.draw(ctx)
#		Screen.TabelCard:
#			modal_card_on_tabel.draw(ctx)
#		Screen.Attack:
#			modal_attack.draw(ctx)
	
#	if modal_scroll_list._visible:
#		modal_scroll_list.update()

func get_player(player_id: String) -> Player:
	if client_player1.player_id == player_id:
		return client_player1
	if opp_player1.player_id == player_id:
		return opp_player1
	if client_player2.player_id == player_id:
		return client_player2
	if opp_player2.player_id == player_id:
		return opp_player2
	push_error("Null return get_player")
	return null

func this_player() -> Player:
	return client_player1

#func input(sense: Sense) -> void:	
#	match setting.box.input(sense):
#		Sense.Enter: setting.box.set_hovered(true)
#		Sense.Exit: setting.box.set_hovered(false)
##		Sense.Click: sense.send_action(Sense.ScreenSetting)
#		Sense.Click: 
#			active_screen = Screen.Setting
#			sense.set_clicked(false)
#		_: pass
#	match active_screen:
#		Screen.Board:
#			match end.box.input(sense):
#				Sense.Enter: end.box.set_hovered(true)
#				Sense.Exit: end.box.set_hovered(false)
#				Sense.Click: pass
#				_: pass
#			match match_type:
#				MatchType.OneVsOne:
#					if sense.mouse_pos().y > box.center().y:
#						sense.set_player_id(client_player1.player_id)
#					else:
#						sense.set_player_id(opp_player1.player_id)
#					player_input(client_player1, sense)
#					player_input(opp_player1, sense)
#				MatchType.TwoVsTwo:
#					client_player1.input(sense)
#					opp_player1.input(sense)
#					client_player2.input(sense)
#					opp_player2.input(sense)
#		Screen.Setting:
#			match modal_setting.buttom_play.box.input(sense):
#		#		Sense.Enter: 
#		#		Sense.Exit: 
#				Sense.Click: 
#					active_screen = Screen.Board
#				_: pass
#			match modal_setting.box.input(sense):
#		#		Sense.Enter: 
#		#		Sense.Exit: 
##				Sense.Click: 
#				Sense.ClickOutside:
#					active_screen = Screen.Board
#				_: pass
##				match modal_setting.buttom_setting.box.input(sense):
##			#		Sense.Enter: 
##			#		Sense.Exit: 
##			#		Sense.Click: 
##					_: pass
##				match modal_setting.buttom_exit.box.input(sense):
##			#		Sense.Enter: 
##			#		Sense.Exit: 
##			#		Sense.Click: 
##					_: pass
##			#	box.set_hovered(true)
##			#	box.set_hovered(false)
#		Screen.Deck: 
#			modal_scroll_list.input(sense)
#		Screen.Factorys:
#			modal_scroll_list.input(sense)
#		Screen.Graveyard: 
#			modal_scroll_list.input(sense)
#		Screen.Secrets:
#			modal_scroll_list.input(sense)
#		Screen.Card:
#			modal_card.input(sense)
#		Screen.TabelCard:
#			modal_card_on_tabel.input(sense)
#		Screen.Attack:
#			modal_attack.input(sense)
#
#func player_input(player: Player, sense: Sense) -> void:
#	match player.factorys.box.input(sense):
#		Sense.Enter: 
#			player.factorys.box.set_hovered(true)
#		Sense.Exit: 
#			player.factorys.box.set_hovered(false)
#		Sense.Click: 
#			active_screen = Screen.Factorys
#			sense.set_clicked(false)
#		_: pass
#	match player.secrets.box.input(sense):
#		Sense.Enter: 
#			player.secrets.box.set_hovered(true)
#		Sense.Exit: 
#			player.secrets.box.set_hovered(false)
#		Sense.Click: 
#			active_screen = Screen.Secrets
#			sense.set_clicked(false)
#		_: pass
#	match player.graveyard.box.input(sense):
#		Sense.Enter: 
#			player.graveyard.box.set_hovered(true)
#		Sense.Exit: 
#			player.graveyard.box.set_hovered(false)
#		Sense.Click: 
#			active_screen = Screen.Graveyard
#			sense.set_clicked(false)
#		_: pass
#	match player.deck.box.input(sense):
#		Sense.Enter: 
#			player.deck.box.set_hovered(true)
#		Sense.Exit: 
#			player.deck.box.set_hovered(false)
#		Sense.Click: 
#			active_screen = Screen.Deck
#			sense.set_clicked(false)
#		_: pass
#	match player.hand.box.input(sense):
#		Sense.Enter: 
#			player.hand.focused_card(sense.mouse_pos())
#			player.hand.box.set_hovered(true)
#		Sense.Exit: 
#			player.hand.unfocused_card()
#			player.hand.box.set_hovered(false)
#		Sense.Click: 
#			pass
##			active_screen = Screen.Factorys
##			sense.set_input(sense.mouse_pos(), false)
#		_: pass
#	match player.tabel.box.input(sense):
#		Sense.Enter: 
#			player.tabel.focused_card(sense.mouse_pos())
#			player.tabel.box.set_hovered(true)
#		Sense.Exit: 
#			player.tabel.unfocused_card()
#			player.tabel.box.set_hovered(false)
#		Sense.Click: 
#			pass
##			active_screen = Screen.Factorys
##			sense.set_input(sense.mouse_pos(), false)
#		_: pass

func get_drag_data(ctx: Context, position: Vector2):
	pass
#	if active_screen != Screen.Board:
#		return null
#	var player: Player = this_player()
#	if player.hand.has_focused_card():
#		player.hand.cached_card(player.hand.get_focused_card_id())
#		ctx.start_drag()
#		return { id = "drag" }
#	if player.tabel.has_focused_card():
#		player.tabel.cached_card(player.tabel.get_focused_card_id())
##		arrow_pos
#		ctx.start_targeting()
#		return { id = "target" }


func can_drop_data(ctx: Context, position: Vector2) -> bool:
	pass
#	#TODO add 2  and 3 to box input return (dragging and targeting)
#	if sense.dragging():
#		var player: Player = board.this_player()
#		if player.tabel.has_focused_card():
#			#card is Unit
#			#TODO focus but dont exit
#			player.tabel.left_list.aligment_line()
#			player.tabel.right_list.aligment_line()
#			player.tabel.casting(sense.mouse_pos())
#
#	if sense.targeting():
#		var player: Player = board.get_player(sense.player_id())
#		if player.tabel.has_focused_card():
#			#card is Unit
#			#TODO focus but dont exit
#			player.tabel.focused_card(sense.mouse_pos())
#
#		arrow.clear_points()
#		var curve = Curve2D.new()
#		curve.add_point(
#				arrow_pos,
#		#			screen_size/2,
#				Vector2(0,0),
#		#			TODO:
#		#			(board._rect.size/2).direction_to(get_viewport().size/2) * 75)
#				(config.screen_size/2).direction_to(config.screen_size/2) * 75)
#		curve.add_point(sense.mouse_pos(),
#				Vector2(0, 0), Vector2(0, 0))
#		arrow.set_points(curve.get_baked_points())
	return true

func drop_data(ctx: Context, position: Vector2) -> void:
	pass
#	if sense.dragging():
#		var player: Player = board.this_player()
#		if player.hand.has_focused_card():
#			var card: Card = player.hand.remove_cached_card()
#			card.set_visible(true)
#			player.hand.add_card(card, player.hand.get_focused_card_id())
#		elif player.tabel.has_focused_card():
#			#TODO focus but dont exit
#			var card: Card = player.hand.remove_cached_card()
#			card.set_visible(true)
##			#TODO: if !is_full
#			player.tabel.add_card_to_focus(card)
#		else:
#			player.hand.uncached_card()
#		sense.stop_drag()
#
#	if sense.targeting():
#		var player: Player = board.get_player(sense.player_id())
#		if player.is_this_player:
#			pass
#		else:
#			pass
#			#attck
#		sense.stop_targeting()
#
##	elif sense.targeting() and sense.drag_view_id() == Sense.L_Tabel or sense.drag_view_id() == Sense.R_Tabel:
##		if sense.view_id() == Sense.L_Tabel or  sense.view_id() == Sense.R_Tabel:
##			if sense.player_id() != sense.this_player_id():
###				attack
##				pass
##		else:
##			pass
##		var player: Player = players.get(sense.this_player_id())
##		var card: Card = player.tabel.unselect_card()
##		sense.stop_targeting()
##		for player_id in players:
##			players[player_id].tabel.unhighlight_all_card()
