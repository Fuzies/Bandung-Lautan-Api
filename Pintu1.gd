extends KinematicBody2D

export var labeltext = ""
export(String, FILE, "*.tscn") var scenetarget = null

var scene
var global = Global
var entered = false

onready var labelpintu = $Sprite/Node2D/Label

func _ready():
	labelpintu.visible = false
	labelpintu.text = labeltext
	scene = load(scenetarget).instance().name

func _on_PlayerDetectionZone_body_entered(body):
	labelpintu.visible = true
	entered = true

func _process(delta):
	if entered:
		if Input.is_action_just_pressed("Interract"):
			if scenetarget != null:
				for i in global.location.size():
					if typeof(global.location[i]) == TYPE_STRING and scene == global.location[i]:
						print(global.location[i+2])
						get_tree().change_scene_to(global.location[i+2])
				get_tree().change_scene(scenetarget)
				get_owner().set_player_last_position()
				get_owner().queue_free()
			else:
				print("gagal scene target kosong")

func _on_PlayerDetectionZone_body_exited(body):
	labelpintu.visible = false
	entered = false

