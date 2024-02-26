class_name Lobby extends Node

const PORT := 7677
const MAX_CONNECTIONS := 12

var players := {}

@export var player_info: SaveData


func _ready() -> void:
	pass


func host_game() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_CONNECTIONS)
	assert(error == Error.OK, "Error attempting to create server: %s" % error)
	_upnp_setup()
	multiplayer.multiplayer_peer = peer
	players[1] = player_info.player_name


func _upnp_setup():
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

