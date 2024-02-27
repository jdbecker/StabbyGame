class_name MainMenu extends Control

@onready var player_name_box := %PlayerName

const ERROR_POPUP := preload("res://ui/error_popup.tscn")
const LOADING := preload("res://ui/loading.tscn")
const LOBBY_UI := preload("res://ui/lobby_ui.tscn")


var data: Data
var player_name: String:
	get: return data.player_name


func _ready() -> void:
	data = Data.load_data()
	if data == null: data = Data.new()
	player_name_box.text = player_name


func _on_host_button_pressed():
	if not player_name:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter your name before you can host!"
		add_child(error)
	else:
		data.save_data()
		
		var lobby_ui := LOBBY_UI.instantiate() as LobbyUI
		lobby_ui.data = data
		add_child(lobby_ui)
		lobby_ui.lobby.host_game()


func _on_join_button_pressed():
	if not player_name:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter your name before you can join!"
		add_child(error)
	else:
		data.save_data()
		print("%s is joining!" % player_name)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_player_name_text_changed():
	data.player_name = player_name_box.text as String

