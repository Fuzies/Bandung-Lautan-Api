extends Node2D

onready var player = $YSort/Player

var global = Global

export var nama_tempat = "World Template"

func _ready():
	spawn_player_position()

func set_player_last_position():
	var found = false
	for i in global.location.size():
		if typeof(global.location[i]) == TYPE_STRING and name == global.location[i]:
			global.location[i+1] = player.global_position
			found = true
	if found == false:
		global.location.append(name)
		global.location.append(player.global_position)
	print(global.location)

func spawn_player_position():
	for i in global.location.size():
		if typeof(global.location[i]) == TYPE_STRING and name == global.location[i]:
			player.global_position = global.location[i+1]
