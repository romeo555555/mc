extends Reference
class_name Client

#const proto: Reference = preload("res://protos/buff.gd")

const SERVER_KEY : String = "defaultkey"
const HOST : String = "127.0.0.1"
const PORT : int = 7350
const TIMEOUT = 3
const CLIENT_SCHEME : String = "http" #"https"
const SOCKET_SCHEME : String = "ws" #"wss"
const LOG_LEVEL = NakamaLogger.LOG_LEVEL.DEBUG

#onready var Nakama: Node = preload("res://addons/com.heroiclabs.nakama/Nakama.gd").new()
onready var nkclient: NakamaClient #setget _set_readonly_variable, get_nakama_client
onready var session: NakamaSession #setget set_nakama_session
onready var socket: NakamaSocket #setget _set_readonly_variable

var matchmaker_ticket: NakamaRTAPI.MatchmakerTicket #string #setget _set_readonly_variable, get_matchmaker_ticket
var match_played: NakamaRTAPI.Match #string #setget _set_readonly_variable, get_matchmaker_ticket
var match_session_id: String #setget _set_readonly_variable, get_my_session_id
var match_id: String #setget _set_readonly_variable, get_match_id
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

var _http_adapter = null
var logger = NakamaLogger.new()

#var player: proto.Player


func _init(http_adapter: Node, ws_adapter: Node):
	logger._level = NakamaLogger.LOG_LEVEL.DEBUG
	http_adapter.logger = logger
	ws_adapter.logger = logger
# 	data: Dictionary):
#	var data = {
#	  "Key": "Value",
#	  "AnotherKey": "AnotherValue"
#	}
#	var serialized = JSON.print(data)
	nkclient = NakamaClient.new(http_adapter, SERVER_KEY, CLIENT_SCHEME, HOST, PORT, TIMEOUT)
#	var vars = {
#    "device_os" : OS.get_name,
#    "device_model" : OS.get_model_name,
#    "invite_user_id" : "<some_user_id>,
#	}
	socket = NakamaSocket.new(ws_adapter, HOST, PORT, SOCKET_SCHEME, true)
	var device_id = OS.get_unique_id()
	print(device_id)
	session = yield(nkclient.authenticate_device_async(device_id, null, true, null), "completed")
	if session.is_exception():
		print("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
	var connected : NakamaAsyncResult = yield(socket.connect_async(session), "completed")
	if connected.is_exception():
		print("An error occurred: %s" % connected)
		return
	print("Socket connected.")
	# Check whether a session has expired or is close to expiry
#	if session.expired:
#	    # Attempt to refresh the existing session.
#	    session = yield(client.session_refresh_async(session), "completed)
#	    if session.is_exception():
#	        # Couldn't refresh the session so reauthenticate.
#	        session = yield(client.authenticate_device_async(device_id), "completed")
#	        # Save the new refresh token
#	        <save_file>.set_value("refresh_token", session.refresh_token)
#	    }
#
#	    # Save the new auth token
#	    <save_file>.set_value("auth_token", session.auth_token)
#	}

func run_matchmaker():
#	var min_players = 2
#	var max_players = 10
#	var query = "+skill:>100 mode:sabotage"
#	var string_properties = { "mode": "sabotage" }
#	var numeric_properties = { "skill": 125 }
	var min_players = 1
	var max_players = 1
	var query = ""
	var string_properties = { }
	var numeric_properties = { }
	matchmaker_ticket = yield(
		socket.add_matchmaker_async(query, min_players, max_players, 
			string_properties, numeric_properties), "completed")

func join_to_match(p_matched : NakamaRTAPI.MatchmakerMatched):
	match_played = yield(socket.join_matched_async(p_matched), "completed")

#func send(match_id):
#	yield(socket.send_match_state_async(match_id, op_codes.position, JSON.print(state)), "completed")

#func recive(match_state : NakamaRTAPI.MatchData):
#	match match_state.op_code:
#		op_code.position:
#			# Get the updated position data
#			var position_state = JSON.parse(match_state.data)
#			# Update the game object associated with that player
#			var user = match_state.user_presence.session_id
#			if user in players:
#				# Here we would normally do something like smoothly interpolate to the new position, but for this example let's just set the position directly.
#				players[user].transform.Vector3 = vec(position_state.x, position_state.y, position_state.z)
#		_:
#			print("Unsupported op code.")
