class_name DamageNumber
extends Node2D

onready var label = $LabelContainer/Label
onready var labelContainer = $LabelContainer
onready var animation = $AnimationPlayer

func _ready():
	label.align = 1

func set_values_and_animate(value:String, start_pos:Vector2, height:float, spread:float):
	visible = true
	label.text = value
	animation.play("Rise_And_Fade")
	
	var tween = get_tree().create_tween()
	var end_pos = Vector2(rand_range(-spread, spread), -height) * start_pos
	var tween_length = animation.current_animation_length
	
	tween.tween_property(labelContainer, "position", end_pos,tween_length).from(start_pos)
	
func remove():
	animation.stop()
	visible = false
	
