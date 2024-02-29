class_name Lobby extends Node

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT := 7677
const MAX_CONNECTIONS := 12

var players := {}
var join_code_thread: Thread

@export var data: Data


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func host_game() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_CONNECTIONS)
	assert(error == Error.OK, "Error attempting to create server: %s" % error)
	multiplayer.multiplayer_peer = peer
	players[1] = data.player_name
	player_connected.emit(1)
	join_code_thread = Thread.new()
	join_code_thread.start(_upnp_setup)


func join_game(join_code: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	#var error := peer.create_client(_decode_ip(join_code), PORT)
	var error := peer.create_client("localhost", PORT)
	assert(error == Error.OK, "Error attempting to join: %s" % error)
	multiplayer.multiplayer_peer = peer


func _on_connected_ok() -> void:
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = data.player_name
	player_connected.emit(peer_id)


func _on_player_connected(id: int) -> void:
	_register_player.rpc_id(id, data.player_name)


@rpc("any_peer", "reliable")
func _register_player(new_player_name: String) -> void:
	var new_player_id := multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_name
	player_connected.emit(new_player_id)


func _on_player_disconnected(id) -> void:
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()


func _upnp_setup() -> String:
	var upnp = UPNP.new()
	var discover_result := upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Discover Failed! Error %s" % discover_result)
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), "UPNP Invalid Gateway!")
	var map_result := upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Port Mapping Failed! Error %s" % map_result)
	var ip = upnp.query_external_address()
	var join_code = _encode_ip(ip)
	var rebuilt_ip = _decode_ip(join_code)
	print("Success! Join Address: %s" % ip)
	print("Join code is: %s" % join_code)
	print("Decoded join code is: %s" % rebuilt_ip)
	return join_code


func _encode_ip(ip_address: String) -> String:
	var nums : Array[int] = []
	for num in ip_address.split("."):
		nums.append(num as int)
	return Marshalls.raw_to_base64(nums)


func _decode_ip(encoded_ip: String) -> String:
	var decoded_bytes := Marshalls.base64_to_raw(encoded_ip)
	var ip_address := ""
	for num in decoded_bytes:
		ip_address += str(num) + "."
	return ip_address.rstrip(".")

