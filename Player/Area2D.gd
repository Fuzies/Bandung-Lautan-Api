extends Area2D

var damage = 0
var knockback_vector = Vector2.ZERO
var stat = PlayerStats

func _ready():
	damage = stat.total_attack * 2 #double attack untuk peluru yang diluncurkan
	stat.connect("total_attack_changed", self,"set_hitatk")

func set_hitatk(value):
	damage = stat.total_attack
