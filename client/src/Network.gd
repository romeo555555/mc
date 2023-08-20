extends Reference
class_name Network

onready var client: NakamaClient #setget _set_readonly_variable, get_nakama_client
onready var session: NakamaSession #setget set_nakama_session
onready var socket: NakamaSocket #setget _set_readonly_variable

var match_socket: NakamaSocket #setget _set_readonly_variable
var my_session_id: String #setget _set_readonly_variable, get_my_session_id
var match_id: String #setget _set_readonly_variable, get_match_id
var matchmaker_ticket: String #setget _set_readonly_variable, get_matchmaker_ticket

# RPC variables:
var my_peer_id: int #setget _set_readonly_variable

var players: Dictionary
var _next_peer_id: int

# Internal variable for initializing the socket.
var _nakama_socket_connecting := false
#TODO:
#custom auth
#user registr
#refresh sesion token auth
#get user data
func _init(data: Dictionary):
#	var data = {
#	  "Key": "Value",
#	  "AnotherKey": "AnotherValue"
#	}
	var serialized = JSON.print(data)
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	client.timeout = 10
	var device_id = OS.get_unique_id()
#	var vars = {
#    "device_os" : OS.get_name,
#    "device_model" : OS.get_model_name,
#    "invite_user_id" : "<some_user_id>,
#	}
	session = yield(client.authenticate_device_async(device_id, null, true, data), "completed")
	if session.is_exception():
		print("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
	socket = Nakama.create_socket_from(client)
	var connected : NakamaAsyncResult = yield(socket.connect_async(session), "completed")
	if connected.is_exception():
		print("An error occurred: %s" % connected)
		return
	print("Socket connected.")

func find_match():
	var min_players = 2
	var max_players = 10
	var query = "+skill:>100 mode:sabotage"
	var string_properties = { "mode": "sabotage" }
	var numeric_properties = { "skill": 125 }
	var matchmaker_ticket : NakamaRTAPI.MatchmakerTicket = yield(
		socket.add_matchmaker_async(query, min_players, max_players, 
			string_properties, numeric_properties), "completed")
	socket.connect("received_matchmaker_matched", self, "_on_matchmaker_matched")

func _on_matchmaker_matched(p_matched : NakamaRTAPI.MatchmakerMatched):
	var joined_match : NakamaRTAPI.Match = yield(socket.join_matched_async(p_matched), "completed")

func is_exception():
	pass
