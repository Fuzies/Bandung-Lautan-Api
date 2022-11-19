extends Node2D

const BarelEffect = preload("res://Effect/BarelEffect.tscn")#load Effect hanya sekali untuk banyak objek

func create_barel_effect():
	var barelEffect = BarelEffect.instance()
	get_parent().add_child(barelEffect)#ambil var parent
	barelEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_barel_effect()
	queue_free()
