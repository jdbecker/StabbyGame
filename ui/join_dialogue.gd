class_name JoinDialogue extends CanvasLayer

@onready var join_code := %JoinCode as TextEdit
@onready var confirm_join := %ConfirmJoin as Button

const ERROR_POPUP = preload("res://ui/error_popup.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


func _on_confirm_join_pressed() -> void:
	if not join_code.text:
		var error := ERROR_POPUP.instantiate() as ErrorPopup
		error.desired_title = "Error"
		error.desired_message = "You must enter the join code of the player who is hosting!"
		error.closed.connect(func(): get_tree().paused = true)
		add_child(error)
	else:
		get_tree().paused = false
		queue_free()
