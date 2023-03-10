class_name SaveGame
extends Resource

export var inventoryRes = []
#export var playerpos = Vector2.ZERO
#export(Resource) var world
export var stage2 = false
export var questcomplete = []
const SAVE_GAME_PATH := "res://savegame.tres"

var global = Global

func write_savegame(quest, stage2condition) -> void:
	load_savegame()
	print("Game Saved")
	inventoryRes = load("res://UI/Inventory.tres").items
	questcomplete = quest
	stage2 = stage2condition
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		print("Game Loaded")
		return load(SAVE_GAME_PATH)
	else:
		print("Resource Doesn't Exist")
	return null
