extends Node2D

onready var worldmusic = $AudioStreamPlayer
onready var player = $YSort/Player2/Player

var selfnode
var stage = 1

export var nama_tempat = "Jalan Cilaki no 73"

var global = Global
var saves = preload("res://Save/Saves.gd").new()

func _ready():
	#spawn_player_position()
	#worldmusic.play()
	pass
	
func set_player_last_position():
	var duplicated
	var found = false
	for i in global.location.size():
		if typeof(global.location[i]) == TYPE_STRING and name == global.location[i]:
			global.location[i+1] = player.global_position
			found = true
	if found == false:
		global.location.append(name)
		global.location.append(player.global_position)
		global.location.append(self.duplicate())
	print(global.location)

func spawn_player_position():
	for i in global.location.size():
		if typeof(global.location[i]) == TYPE_STRING and name == global.location[i]:
			player.global_position = global.location[i+1]
	
func set_player_position(vector2d):
	player.global_position = vector2d

func get_current_node():
	return self.duplicate()

func get_player_position():
	return player.global_position
