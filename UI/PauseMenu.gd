extends Control

var is_paused = false setget set_is_paused
var inventory = preload("res://UI/Inventory.tres")
var saves = preload("res://Save/Saves.gd").new()
var currentworld

func _ready():
	currentworld = get_owner().get_owner()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeButton_pressed():
	self.is_paused = false

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_SaveButton_pressed():
	saves.write_savegame()

func _on_LoadButton_pressed():
	set_is_paused(false)
	var savesRes = saves.load_savegame()
	inventory.items = savesRes.inventoryRes
	inventory.set_loaded_inventory(savesRes.inventoryRes)
#	print(savesRes.world)
#	print(savesRes.playerpos)
#	get_tree().change_scene_to(savesRes.world)
#	if currentworld != null:
#		currentworld.set_player_position(savesRes.playerpos)
	
