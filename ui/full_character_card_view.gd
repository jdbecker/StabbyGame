class_name FullCharacterCardView extends Control

@export var character: Character : set = _set_character

@onready var clan_color := %Clan as WoundUI
@onready var rank = %Rank as WoundUI
@onready var wound_1 = %Wound1 as WoundUI
@onready var wound_2 = %Wound2 as WoundUI
@onready var ability_description = %AbilityDescription as RichTextLabel
@onready var clue_color = %ClueColor as WoundUI
@onready var neighbor_name = %NeighborName as Label
@onready var neighbor_clue_color = %NeighborClueColor as WoundUI


func _set_character(value: Character) -> void:
	character = value.duplicate() as Character
	
	if not is_node_ready():
		await ready
	
	clan_color.clan = character.clan
	ability_description.text = character.ability_description
	clue_color.clan = character.clue_color
	rank.set_rank(character.rank)
	if character.rank == Character.Rank.INQUISITOR:
		wound_1.desired_label = "any"
		wound_2.desired_label = "any"
		wound_1.clan = Character.Clan.BLUE
		wound_2.clan = Character.Clan.RED
	else:
		assert(character.wound_pool.size() == 3, "Invalid character resource! Should have exactly 3 wounds in the wound pool!")
		wound_1.set_affiliation(character.wound_pool[1])
		wound_2.set_affiliation(character.wound_pool[2])


func _on_hide_button_pressed():
	hide()
