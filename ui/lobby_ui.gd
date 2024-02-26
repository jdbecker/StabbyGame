class_name LobbyUI extends Control

@export var save_data: SaveData : set = _set_save_data

@onready var join_code := %JoinCode
@onready var player_list := %PlayerList
@onready var player_count := %PlayerCount
@onready var lobby := $Lobby as Lobby


func _set_save_data(value: SaveData) -> void:
	if not is_node_ready():
		await ready
	
	save_data = value
	lobby.player_info = save_data


func _on_back_button_pressed():
	queue_free()


func _on_start_button_pressed():
	print("Starting the game with %s players" % [player_count.text as String])
