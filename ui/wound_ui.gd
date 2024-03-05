class_name WoundUI extends Control

@export var clan := Character.Clan.UNKNOWN : set = _set_clan
@export var desired_label := "" : set = _set_label
@export var active := true : set = _set_active

@onready var _label := %Label as Label

const UNKNOWN_COLOR := "646464"
const BLUE_COLOR := "000075"
const RED_COLOR := "750000"
const PURPLE_COLOR := "3c003c"


func set_affiliation(desired_clan: Character.Wound) -> void:
	match desired_clan:
		Character.Wound.BLUE: clan = Character.Clan.BLUE
		Character.Wound.RED: clan = Character.Clan.RED
		_: clan = Character.Clan.UNKNOWN
	desired_label = "?" if clan == Character.Clan.UNKNOWN else ""


func set_rank(desired_rank: Character.Rank) -> void:
	if desired_rank == Character.Rank.INQUISITOR:
		desired_label = "+"
	else:
		desired_label = str(desired_rank + 1)


func _set_clan(value: Character.Clan) -> void:
	clan = value
	
	if not is_node_ready():
		await ready
	
	match clan:
		Character.Clan.UNKNOWN:
			self_modulate = UNKNOWN_COLOR
		Character.Clan.BLUE:
			self_modulate = BLUE_COLOR
		Character.Clan.RED:
			self_modulate = RED_COLOR
		Character.Clan.PURPLE:
			self_modulate = PURPLE_COLOR


func _set_label(value: String) -> void:
	desired_label = value
	
	if not is_node_ready():
		await ready
	
	_label.text = desired_label


func _set_active(value: bool) -> void:
	active = value
	if not is_node_ready():
		await ready
	
	modulate = "ffffffff" if active else "ffffff40"
