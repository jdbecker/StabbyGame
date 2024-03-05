class_name Data extends Resource

const FILE_LOCATION := "user://savedata.tres"

@export var player_name: String
@export var character: Character
@export var has_dagger: bool = false


static func load_data() -> Data:
	if FileAccess.file_exists(FILE_LOCATION):
		return ResourceLoader.load(FILE_LOCATION) as Data
	else:
		return null


func save_data() -> void:
	var err := ResourceSaver.save(self, FILE_LOCATION)
	assert(err == OK, "Failed to save!")

