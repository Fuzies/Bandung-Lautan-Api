extends Control

onready var menumusic = $AudioStreamPlayer

func _ready():
	menumusic.play()
	$VBoxContainer/StartButton.grab_focus()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_StartButton_pressed():
	get_tree().change_scene("res://UI/Menu and Stages/Stages.tscn")
	queue_free()

func _on_HelpButton_pressed():
	get_tree().change_scene("res://UI/Tutorial.tscn")
