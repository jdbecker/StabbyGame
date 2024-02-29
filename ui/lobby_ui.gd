class_name LobbyUI extends Control

@export var data: Data : set = _set_data
@export var join_code: String : set = _set_join_code

const ERROR_POPUP := preload("res://ui/error_popup.tscn")

@onready var join_code_ui := %JoinCode as TextEdit
@onready var player_list := %PlayerList as VBoxContainer
@onready var player_count := %PlayerCount as Label
@onready var lobby := $Lobby as Lobby


func _ready() -> void:
	if join_code:
		lobby.join_game(join_code)


func _process(_delta) -> void:
	if not join_code and not lobby.join_code_thread.is_alive():
		join_code = lobby.join_code_thread.wait_to_finish()
		join_code_ui.select_all()


func _set_data(value: Data) -> void:
	data = value

	if not is_node_ready():
		await ready
	
	lobby.data = data


func _set_join_code(value: String) -> void:
	join_code = value

	if not is_node_ready():
		await ready
	
	join_code_ui.text = join_code


func _on_start_button_pressed():
	if lobby.players.size() < 6:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "Not enough players! You must have at least 6 players to start!"
		add_child(error)
	else:
		print("Starting the game with %s players" % [player_count.text as String])


func _on_lobby_player_connected(_peer_id) -> void:
	for child: Node in player_list.get_children():
		child.queue_free()
	var player_ids := lobby.players.keys()
	player_ids.sort()
	for id in player_ids:
		var player_label := Label.new()
		player_label.text = lobby.players[id]
		player_list.add_child(player_label)
	player_count.text = str(lobby.players.size())
