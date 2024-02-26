class_name SaveData extends Resource

const FILE_LOCATION := "user://savedata.tres"

@export var player_name: String


static func load_data() -> SaveData:
	if FileAccess.file_exists(FILE_LOCATION):
		return ResourceLoader.load(FILE_LOCATION) as SaveData
	else:
		return null


func save_data() -> void:
	var err := ResourceSaver.save(self, FILE_LOCATION)
	assert(err == OK, "Failed to save!")

