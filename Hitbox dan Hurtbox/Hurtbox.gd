extends Area2D

const HitEffect = preload("res://Effect/HitEffect.tscn")
 
var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true: 
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):#berikan buff invincible selama durasi waktu tertentu
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout(): #lamanya buff invincible berakhir
	self.invincible = false

func _on_Hurtbox_invincibility_started(): #Mask Collision dimatikan
	set_deferred("monitoring", false) #set_deffered supaya bisa ubah monitorable saat _phisic_process

func _on_Hurtbox_invincibility_ended(): #Mask Collision dinyalakan 
	monitoring = true
