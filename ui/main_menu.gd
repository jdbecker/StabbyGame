class_name MainMenu extends Control

@onready var player_name = %PlayerName
const ERROR_POPUP := preload("res://ui/error_popup.tscn")



func _on_host_button_pressed():
	if not player_name.text:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter your name before you can host!"
		add_child(error)
	else:
		print("%s is hosting!" % player_name.text)


func _on_join_button_pressed():
	if not player_name.text:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter your name before you can join!"
		add_child(error)
	else:
		print("%s is joining!" % player_name.text)


func _on_quit_button_pressed():
	get_tree().quit()
