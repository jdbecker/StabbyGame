class_name MainMenu extends Control

@onready var player_name_box := %PlayerName

const ERROR_POPUP := preload("res://ui/error_popup.tscn")
const LOBBY_UI := preload("res://ui/lobby_ui.tscn")

var save_data: SaveData
var player_name: String:
	get: return save_data.player_name


func _ready() -> void:
	save_data = SaveData.load_data()
	if save_data == null: save_data = SaveData.new()
	player_name_box.text = player_name


func _on_host_button_pressed():
	if not player_name:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter your name before you can host!"
		add_child(error)
	else:
		save_data.save_data()
		var lobby := LOBBY_UI.instantiate() as LobbyUI
		lobby.save_data = save_data
		add_child(lobby)
		lobby.lobby.host_game.call_deferred()
		await lobby.ready


func _on_join_button_pressed():
	if not player_name:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter your name before you can join!"
		add_child(error)
	else:
		save_data.save_data()
		print("%s is joining!" % player_name)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_player_name_text_changed():
	save_data.player_name = player_name_box.text as String

