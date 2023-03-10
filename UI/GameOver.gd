extends Control

onready var stat = PlayerStats

func _ready():
	stat.connect("death", self, "Gameover")

func Gameover():
	self.visible = true

func _on_Quit_pressed():
	get_tree().quit()

func _on_Restart_pressed():
	stat.set_health(100)
	var stage = get_parent().get_parent().stage
	if stage == 1 :
		get_tree().change_scene("res://World/World.tscn")
	if stage == 2:
		get_tree().change_scene("res://World/BalaiDKA.tscn")
