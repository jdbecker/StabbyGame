class_name ErrorPopup extends Control

@export var desired_title: String : set = _set_title
@export var desired_message: String : set = _set_message

@onready var title = %Title
@onready var message_box = %MessageBox


func _ready() -> void:
	get_tree().paused = true


func _set_title(value: String) -> void:
	desired_title = value
	
	if not is_node_ready():
		await ready
	
	title.text = desired_title


func _set_message(value: String) -> void:
	desired_message = value
	
	if not is_node_ready():
		await ready
	
	message_box.text = desired_message


func _on_button_pressed():
	get_tree().paused = false
	queue_free()
