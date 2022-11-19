extends Area2D
var stats = PlayerStats
var damage = 0 # damage default = 0

func _ready():
	damage = stats.total_attack
	stats.connect("total_attack_changed", self,"set_hitatk")

func set_hitatk(value):
	damage = stats.total_attack
