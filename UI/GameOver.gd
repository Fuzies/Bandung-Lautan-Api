extends Control

onready var stat = PlayerStats

func _ready():
	stat.connect("death", self, "Gameover")

func Gameover():
	self.visible = true

func _on_Quit_pressed():
	get_tree().quit()

func _on_Restart_pressed():
	pass #diganti ulang stage
