extends Object
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
var config: Config = Config.new()
enum MatchType { OneVsOne, TwoVsTwo }
var match_type: int = 0
var box: Box = Box.new()
var texture: Texture = load("res://assets/error.png") as Texture
var end: End = End.new()
#var players: Dictionary = {}
var client_player1: Player = Player.new()
var client_player2: Player = null
var opp_player1: Player = Player.new()
var opp_player2: Player = null

var setting: Setting = Setting.new()
var modal_setting: ModalSetting = ModalSetting.new()
var modal_attack = ModalAttack.new()
var modal_card = ModalCard.new()
var modal_card_on_tabel = ModalCardOnTabel.new()
var modal_choose_card = ModalChooseCard.new()
var modal_scroll_list: ModalScrollList

func init(modal_scroll_list: Control) -> void:
	config = modal_scroll_list.config
	setting.box.set_rect(Rect2(Vector2(30,30), Vector2(100, 100)))
	modal_setting.init(config.screen_size, Vector2(700, 700), 100)
	
	modal_scroll_list = modal_scroll_list as ModalScrollList
	modal_scroll_list.set_setting(setting)
	box.set_rect(Rect2(Vector2.ZERO, config.screen_size))
	match_type = MatchType.OneVsOne
	client_player1.box.set_rect(box.relative_rect(Box.BottomHSplit))
	client_player1.init(true, "Client")
	opp_player1.box.set_rect(box.relative_rect(Box.TopHSplit))
	opp_player1.init(false, "Client")

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

func input(sense: Sense) -> void:	
	match setting.box.input(sense):
		Sense.Enter: setting.box.set_hovered(true)
		Sense.Exit: setting.box.set_hovered(false)
#		Sense.Click: sense.send_action(Sense.ScreenSetting)
		Sense.Click: 
			active_screen = Screen.Setting
			sense.set_input(sense.mouse_pos(), false)
		_: pass
	match active_screen:
		Screen.Board:
			match end.box.input(sense):
				Sense.Enter: end.box.set_hovered(true)
				Sense.Exit: end.box.set_hovered(false)
				Sense.Click: pass
				_: pass
			match match_type:
				MatchType.OneVsOne:
					if sense.mouse_pos().y > box.center().y:
						sense.set_player_id(client_player1.player_id)
					else:
						sense.set_player_id(opp_player1.player_id)
					player_input(client_player1, sense)
					player_input(opp_player1, sense)
				MatchType.TwoVsTwo:
					client_player1.input(sense)
					opp_player1.input(sense)
					client_player2.input(sense)
					opp_player2.input(sense)
		Screen.Setting:
			match modal_setting.buttom_play.box.input(sense):
		#		Sense.Enter: 
		#		Sense.Exit: 
				Sense.Click: 
					active_screen = Screen.Board
				_: pass
			match modal_setting.box.input(sense):
		#		Sense.Enter: 
		#		Sense.Exit: 
#				Sense.Click: 
				Sense.ClickOutside:
					active_screen = Screen.Board
				_: pass
#				match modal_setting.buttom_setting.box.input(sense):
#			#		Sense.Enter: 
#			#		Sense.Exit: 
#			#		Sense.Click: 
#					_: pass
#				match modal_setting.buttom_exit.box.input(sense):
#			#		Sense.Enter: 
#			#		Sense.Exit: 
#			#		Sense.Click: 
#					_: pass
#			#	box.set_hovered(true)
#			#	box.set_hovered(false)
		Screen.Deck: 
			modal_scroll_list.input(sense)
		Screen.Factorys:
			modal_scroll_list.input(sense)
		Screen.Graveyard: 
			modal_scroll_list.input(sense)
		Screen.Secrets:
			modal_scroll_list.input(sense)
		Screen.Card:
			modal_card.input(sense)
		Screen.TabelCard:
			modal_card_on_tabel.input(sense)
		Screen.Attack:
			modal_attack.input(sense)

func player_input(player: Player, sense: Sense) -> void:
	match player.factorys.box.input(sense):
		Sense.Enter: 
			player.factorys.box.set_hovered(true)
		Sense.Exit: 
			player.factorys.box.set_hovered(false)
		Sense.Click: 
			active_screen = Screen.Factorys
			sense.set_input(sense.mouse_pos(), false)
		_: pass
	match player.secrets.box.input(sense):
		Sense.Enter: 
			player.secrets.box.set_hovered(true)
		Sense.Exit: 
			player.secrets.box.set_hovered(false)
		Sense.Click: 
			active_screen = Screen.Secrets
			sense.set_input(sense.mouse_pos(), false)
		_: pass
	match player.graveyard.box.input(sense):
		Sense.Enter: 
			player.graveyard.box.set_hovered(true)
		Sense.Exit: 
			player.graveyard.box.set_hovered(false)
		Sense.Click: 
			active_screen = Screen.Graveyard
			sense.set_input(sense.mouse_pos(), false)
		_: pass
	match player.deck.box.input(sense):
		Sense.Enter: 
			player.deck.box.set_hovered(true)
		Sense.Exit: 
			player.deck.box.set_hovered(false)
		Sense.Click: 
			active_screen = Screen.Deck
			sense.set_input(sense.mouse_pos(), false)
		_: pass
	match player.hand.box.input(sense):
		Sense.Enter: 
			player.hand.focused_card(sense.mouse_pos())
			player.hand.box.set_hovered(true)
		Sense.Exit: 
			player.hand.unfocused_card()
			player.hand.box.set_hovered(false)
		Sense.Click: 
			pass
#			active_screen = Screen.Factorys
#			sense.set_input(sense.mouse_pos(), false)
		_: pass
	match player.tabel.box.input(sense):
		Sense.Enter: 
			player.tabel.focused_card(sense.mouse_pos())
			player.tabel.box.set_hovered(true)
		Sense.Exit: 
			player.tabel.unfocused_card()
			player.tabel.box.set_hovered(false)
		Sense.Click: 
			pass
#			active_screen = Screen.Factorys
#			sense.set_input(sense.mouse_pos(), false)
		_: pass

func draw_dragging(ctx: CanvasItem, mouse_pos: Vector2) -> void:
	client_player1.hand.draw_cached_card(ctx, mouse_pos)

func draw(ctx: CanvasItem) -> void:
	ctx.draw_texture_rect(texture, box.rect(), false)
	#	end.draw(self)
	match match_type:
		MatchType.OneVsOne:
			opp_player1.draw(ctx)
			client_player1.draw(ctx)
		MatchType.TwoVsTwo:
			opp_player2.draw(ctx)
			client_player2.draw(ctx)
			opp_player1.draw(ctx)
			client_player1.draw(ctx)
	setting.draw(ctx)
	match active_screen:
		Screen.Setting:
			modal_setting.draw(ctx)
		Screen.Deck: 
			modal_scroll_list.draw(ctx)
		Screen.Factorys:
			modal_scroll_list.draw(ctx)
		Screen.Graveyard: 
			modal_scroll_list.draw(ctx)
		Screen.Secrets:
			modal_scroll_list.draw(ctx)
		Screen.Card:
			modal_card.draw(ctx)
		Screen.TabelCard:
			modal_card_on_tabel.draw(ctx)
		Screen.Attack:
			modal_attack.draw(ctx)
	
	
#	if modal_scroll_list._visible:
#		modal_scroll_list.update()
