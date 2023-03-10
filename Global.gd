extends Node

var camera = null
var player_last_position = Vector2.ZERO
var location = []
var stage2 = false
var questcompleted = []

var saves = preload("res://Save/Saves.gd").new()

func saveprogress():
	saves.write_savegame(questcompleted, stage2)

func set_questcompleted(quests):
	questcompleted = quests
	print(questcompleted)

func get_questcompleted():
	return questcompleted

func set_stage2_condition(boolean):
	stage2 = boolean

#Created By Alexander Tommy Kurniawan
