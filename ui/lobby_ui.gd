class_name LobbyUI extends Control

@export var data: Data : set = _set_data

@onready var join_code := %JoinCode
@onready var player_list := %PlayerList
@onready var player_count := %PlayerCount
@onready var lobby := $Lobby as Lobby


func _ready() -> void:
	lobby.join_code_created.connect(_on_lobby_join_code_created)


func _process(_delta) -> void:
	if join_code.text == "--------" and not lobby.join_code_thread.is_alive():
		join_code.text = lobby.join_code_thread.wait_to_finish()
		join_code.select_all()


func _set_data(value: Data) -> void:
	if not is_node_ready():
		await ready
	
	data = value
	lobby.data = data


func _on_back_button_pressed():
	queue_free()


func _on_start_button_pressed():
	print("Starting the game with %s players" % [player_count.text as String])


func _on_lobby_join_code_created(code) -> void:
	join_code.editable = true
	join_code.text = code
	join_code.editable = false
