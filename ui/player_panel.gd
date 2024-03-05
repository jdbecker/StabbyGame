class_name PlayerPanel extends PanelContainer

@export var player_data: Data : set = _set_player_data
@export var has_dagger: bool = false

@onready var player_name := %PlayerName as Label
@onready var dagger_button := %DaggerButton as Button
@onready var wound_ui_1 := %WoundUI1 as WoundUI
@onready var wound_ui_2 := %WoundUI2 as WoundUI
@onready var wound_ui_3 := %WoundUI3 as WoundUI


func _set_player_data(value: Data) -> void:
	player_data = value
	
	if not is_node_ready():
		await ready
	
	print("set player name to %s" % player_data.player_name)
	player_name.text = player_data.player_name
	wound_ui_1.set_rank(player_data.character.rank)
	wound_ui_2.set_affiliation(player_data.character.wound_pool[1])
	wound_ui_3.set_affiliation(player_data.character.wound_pool[2])
	dagger_button.visible = has_dagger
