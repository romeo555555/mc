extends Object
const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")

class Mana extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("red", colyseus.NUMBER),
			colyseus.Field.new("blue", colyseus.NUMBER),
			colyseus.Field.new("green", colyseus.NUMBER),
			colyseus.Field.new("white", colyseus.NUMBER),
			colyseus.Field.new("black", colyseus.NUMBER),
		]

class Ability extends colyseus.Schema:
	static func define_fields():
		return []
class Attribute extends colyseus.Schema:
	static func define_fields():
		return []

class Card extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("id", colyseus.STRING),
			colyseus.Field.new("name", colyseus.STRING),
			colyseus.Field.new("desc", colyseus.STRING),
			colyseus.Field.new("cost", colyseus.Array, Mana),
		]
class Unit extends Card:
	static func define_fields():
		return [
			colyseus.Field.new("ability", colyseus.Array, Ability),
			colyseus.Field.new("attribute", colyseus.Array, Attribute),
			colyseus.Field.new("healty", colyseus.NUMBER),
			colyseus.Field.new("attack", colyseus.NUMBER),
		]
class Item extends Card:
	static func define_fields():
		return []
class Spell extends Card:
	static func define_fields():
		return []
class Factory extends Card:
	static func define_fields():
		return [
			colyseus.Field.new("add", colyseus.REF, Mana),
			colyseus.Field.new("sub", colyseus.REF, Mana),
			colyseus.Field.new("one", colyseus.REF, Mana),
		]
class Zone extends Card:
	static func define_fields():
		return []
		
class Player extends colyseus.Schema:
	static func define_fields():
		return [
#			colyseus.Field.new("id", colyseus.STRING),
#			colyseus.Field.new("name", colyseus.STRING),
#			colyseus.Field.new("mana", colyseus.REF, Mana),
#			colyseus.Field.new("factorys", colyseus.Array, Factory),
#			colyseus.Field.new("dead", colyseus.Array, Card),
##			colyseus.Field.new("deck", colyseus.Array, Card),
##			colyseus.Field.new("hand", colyseus.Array, Card),
#			colyseus.Field.new("tabel", colyseus.Array, Card),
		]
	var node
	
#	func _to_string():
#		return str("") #"(",self.x,",",self.y,")")

class GameState extends colyseus.Schema:
	static func define_fields():
		return [
#			colyseus.Field.new("players", colyseus.Map, Player),
		]


#ui
#dragdrop
#Datamodel
#predata
#back
#card generator
#bch

#func draw_circle_arc(center, radius, angle_from, angle_to, color):
#	var nb_points = 32
#	var points_arc = PoolVector2Array()
#
#	for i in range(nb_points + 1):
#		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
#		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#
#	$Arrow.points = points_arc
#####
#	for index_point in range(nb_points):
#		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
###
#	var center = Vector2(200, 200)
#	var radius = 80
#	var angle_from = 75
#	var angle_to = 195
#	var color = Color(1.0, 0.0, 0.0)
##	draw_circle_arc( center, radius, angle_from, angle_to, color )
#	var curve = Curve2D.new()
#	curve.add_point(
#			Vector2(0,0),
#			Vector2(0,0),
#			Vector2(0,0).direction_to(screen_size/2) * 75)
#	curve.add_point(position,
##			+card_half_size + final_point),
#			Vector2(0, 0), Vector2(0, 0))
#	$Arrow.set_points(curve.get_baked_points())
#	$Arrow.set_curve(curve)
#	set_points(curve.get_baked_points())
	
	
#	$Arrow.add_point(Vector2.ZERO, 1)
#	$Arrow.add_point(position, 2)

####
#local cursor = require "in.cursor"
#local ColyseusClient = require "colyseus.client"
#
#WIDTH = tonumber(sys.get_config("display.width"))
#HEIGHT = tonumber(sys.get_config("display.height"))
#print(WIDTH ..' and ' .. HEIGHT)
#-- left bottom x = 0.0 y = 0.0
#g_width, g_height, g_card_w, g_card_h = 1920.0, 1080.0, 200.0, 200.0
#
#g_half_width, g_half_height = g_width * 0.5, g_height * 0.5
#
#g_card_kw, g_card_kh = g_card_w / g_width, g_card_h / g_height
#-- g_card_indent_x, g_card_indent_y = 
#
#g_card_size = vmath.vector3(200.0, 200.0, 0.0)
#g_card_indent = vmath.vector3(10.0, 0.0, 0.0)
#g_client_hand = vmath.vector3(0.0, 0.0 + g_card_size.y * 0.5, 0.0)
#g_opp_hand = vmath.vector3(0.0, g_height - g_card_size.y * 0.5, 0.0) 
#
#g_client = { 
#	id = "",
#}
#g_current_turn = nil
#g_players = {}
#g_room = {}
#
#function alignment(line_pos, cards, count)
#	local count = count - 1
#	local x = count * (g_card_size.x + g_card_indent.x) + g_card_size.x * 0.5
#	local start_x = (g_width - x) * 0.5
#	for i,h in pairs(cards) do
#		print("start_x:", start_x, x, h)
#		go.set_position(vmath.vector3(start_x, line_pos.y, line_pos.z), h)
#		start_x = start_x + g_card_size.x + g_card_indent.x
#		-- print(line_pos, count, start_x)
#	end
#end
#
#function window_callback(self, event, data)
#	if event == window.WINDOW_EVENT_FOCUS_LOST then
#		print("window.WINDOW_EVENT_FOCUS_LOST")
#	elseif event == window.WINDOW_EVENT_FOCUS_GAINED then
#		print("window.WINDOW_EVENT_FOCUS_GAINED")
#	elseif event == window.WINDOW_EVENT_ICONFIED then
#		print("window.WINDOW_EVENT_ICONFIED")
#	elseif event == window.WINDOW_EVENT_DEICONIFIED then
#		print("window.WINDOW_EVENT_DEICONIFIED")
#	elseif event == window.WINDOW_EVENT_RESIZED then
#		print("Window resized: ", data.width, data.height)
#	end
#end
#
#function init(self)	
#	window.set_listener(window_callback)
#	msg.post(".", "acquire_input_focus")
#	msg.post("@render:", "use_fixed_fit_projection", { near = -3, far = 3 })
#
#	local client = ColyseusClient.new("ws://localhost:2567")
#	client:join_or_create("my_room", g_client, function(err, _room)
#		if err then
#			print("JOIN ERROR: " .. err)
#			return
#		end
#		print("joined successfully")
#
#		g_room = _room
#		g_room.state.players:on_add(function (player, key)
#			print("player has been added at", key, " name: ", player.name);
#			g_players[key] = {
#				tabel_size = 0,
#				tabel = {},
#				hand_size = 0,
#				hand = {},
#			}
#			-- detecting changes on object properties
#			-- player:listen("deck", function(value, previous_value)
#			-- 	print(value)
#			-- 	print(previousValue)
#			-- end)
#			g_room:on_message("startMatch", function(opt)
#				g_client.id = opt.id
#				g_current_turn = opt.current_turn
#				-- g_opp_id = msg.opp_id
#				print("startMatch", g_current_turn)
#			end)
#			g_room:on_message("addCard", function(opt)
#				print("addCard player:", opt.id)
#				print(opt.card.name)
#				msg.post(".", "addCard", opt)
#			end)
#		end)
#	end)
#end
#
#function on_input(self, action_id, action)
#	if not g_current_turn then return end
#	-- print("wg:", 
#	-- sys.get_config("render.get_width"),
#	-- sys.get_config("render.get_height"), "window:",
#	-- sys.get_config("render.get_window_width"),
#	-- sys.get_config("render.get_window_height"))
#	-- 
#	-- print("disp",
#	-- sys.get_config("display.width"),
#	-- sys.get_config("display.height"),"window:",
#	-- sys.get_config("display.get_window_width"),
#	-- sys.get_config("display.get_window_height"))
#
#	-- local k = g_players[g_client.id].hand
#	-- for i,h in pairs(k) do
#	-- 	print(h.name)
#	-- end
#	-- if action_id == hash("touch") and action.pressed then
#	-- 	print("Touch!")
#	-- end
#	-- print("a", action.x, action.y)
#	-- print("as", action.screen_x, action.screen_y)
#
#
#
#	-- print(window.get_size())
#	local x, y = action.x, action.y
#	if action.pressed then
#		go.set_position(vmath.vector3(x,y,0), "/tabel_card")
#	end
#	-- msg.post("@render:", "screen_to_world", { x = x, y = y, z = 0.0 })
#	-- local x, y = msg.post("@render:", "screen_to_world", { x = x, y = y, z = 0.0 })
#	if y < g_client_hand.y then
#		print("phand")
#		-- local player = g_players[g_client.id]
#		-- alignment(g_client_hand, player.hand, player.hand_size)
#	elseif y > g_opp_hand.y - g_card_size.y then
#		print("ohand")
#		-- local player = g_players[g_client.id]
#		-- alignment(g_opp_hand, player.hand, player.hand_size)
#	else
#		if y < g_half_height then
#			print("ptabel")
#			-- local player = g_players[g_client.id]
#			-- alignment(g_half_height, player.tabel, player.tabel_size)
#		else
#			print("otabel")
#			-- local player = g_players[g_client.id]
#			-- alignment(g_half_height, player.tabel, player.tabel_size)
#		end
#	end
#	return true
#end
#
#function update(self, dt)
#	if self.drag then
#		local pos = go.get_position()
#		go.set_position(pos, "/tabel_card")
#	end
#	-- local width2, height2 = window.get_size()
#	-- if width2 > 1280 or height2 > 720 then
#	-- 	if height2 - 720 > width2 - 1280 then
#	-- 		msg.post("@render:", "use_fixed_projection", { zoom = height2 / 720 })
#	-- 	else
#	-- 		msg.post("@render:", "use_fixed_projection", { zoom = width2 / 720 })
#	-- 	end
#	-- else
#	-- 	msg.post("@render:", "use_fixed_projection", { zoom = 1 })
#	-- end
#end
#
#function on_message(self, message_id, opt, sender)
#	if message_id == hash("addCard") then
#		if opt.card then
#			local hash_id = factory.create("#factory_tabel_card", nil, nil, nil)
#			local player = g_players[g_client.id]
#			player.hand[opt.card.id] = hash_id
#			player.hand_size = player.hand_size + 1
#			alignment(g_client_hand, player.hand, player.hand_size)
#		else
#			--flipped card
#			-- localhash_id = factory.create("#factory_tabel_card", nil, nil, v)
#			-- 
#			-- local player = g_players[g_client.id]
#			-- player.hand[opt.id] = hash_id
#			-- player.hand_size = player.hand_size + 1
#			-- alignment(, player.hand, player.hand_size)
#		end
#		print("last")
#		for i,h in pairs(g_players[g_client.id].hand) do
#			print(h)
#		end
#	else
#	end
#	-- if message_id == cursor.OVER then
#	-- 	print("Cursor over", message.id, message.group, message.x, message.y)
#	-- 	--if message.group == hash("green_dropzone") then
#	-- elseif message_id == cursor.OUT then
#	-- 	print("Cursor out", message.id, message.group, message.x, message.y)
#	-- elseif message_id == cursor.RELEASED then
#	-- 	print("Released", message.id, message.group, message.x, message.y)
#	-- elseif message_id == cursor.CLICKED then
#	-- 	print("Clicked", message.id, message.group, message.x, message.y)
#	-- elseif message_id == cursor.DRAG_START then
#	-- 	print("Drag started", message.id, message.group, message.x, message.y)
#	-- 	self.drag = true
#	-- elseif message_id == cursor.DRAG_END then
#	-- 	print("Drag ended", message.id, message.group, message.x, message.y)
#	-- 	self.drag = false
#	-- end
#end
#
#function rect_has_point(x, y, size, p)
#	if p.x < x then
#		return false
#	end
#	if p.y < y then
#		return false
#	end
#	if p.x >= (x + size.x) then
#		return false
#	end
#	if p.y >= (y + size.y) then
#		return false
#	end
#	return true
#end
#- #TODO
#--window calculation card_size_k 16:9
#--window init and resize calback
#--contain_point
#--hovered
#--hovered to selct or drag 
#--drop
#--arrow
#--mut card state 
#--add item
#--add factory
#--add spell
#--animation
#--deck and factorys
#
#-- #const hand_capacity := 5
#-- #hovered card and click
#-- var hand_capacity := 5
#-- 
#-- var hand_w = hand_capacity * card_size.x + (hand_capacity - 1) * card_offset.x
#-- var start_x = (screen_size.x - hand_w) * 0.5
#-- 
#-- for i in range(hand_capacity):
#-- var card = $HandCard.duplicate()
#-- add_child(card)
#-- card.set_visible(true)
#-- card.set_position(Vector2(start_x, player_hand_y))
#-- start_x += card_size.x + card_offset.x
