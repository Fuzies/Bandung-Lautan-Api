extends Node

export(int) var max_health = 1 setget set_max_health#export untuk mengatur nilai max_health saat di instance di node lain
var health = max_health setget set_health
export(int) var base_attack = 1  setget set_base_attack
var equipment_attack = 0 setget set_equipment_attack
var equipment_hp = 0 setget set_equipment_hp
var buff_attack = 0
var buff_hp = 1
var total_attack = 0 setget set_total_attack
var total_hp = 0 setget set_total_hp 
const zero = 0
#setget memanggil fungsi ketika terjadi perubahan pada variabel yang terpilih.
#onready berjalan setelah func _ready berjalan maka var health baru diisi max_health

signal death
signal health_changed(value)
signal max_health_changed(value)
signal base_attack_changed(value)
signal attack_changed(value)
signal equipment_attack_changed(value)
signal equipment_hp_changed(value)
signal total_attack_changed(value)
signal total_hp_changed(value)

func _ready():
	self.health = max_health
	total_hp = equipment_hp + buff_hp + max_health
	total_attack = equipment_attack + buff_attack + base_attack

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("death")

func set_base_attack(value):
	base_attack = value
	if base_attack <= 1:
		base_attack = 1
	emit_signal("base_attack_changed", base_attack)
	
func set_equipment_attack(value):
	equipment_attack = value
	emit_signal("equipment_attack_changed", equipment_attack)

func set_equipment_hp(value):
	equipment_hp = value
	emit_signal("equipment_hp_changed", equipment_hp)

func set_total_attack(value):
	total_attack = zero
	total_attack += value
	emit_signal("total_attack_changed")

func set_total_hp(value):
	total_attack = zero
	total_attack += value
	emit_signal("total_hp_changed")

func heal(value):
	if health + value >= total_hp:
		health = total_hp
	else:
		health = health + value
	emit_signal("health_changed", health)

func increase_max_health(value):
	max_health = max_health + value
	emit_signal("max_health_changed", max_health)

func decrease_max_health(value):
	if max_health - value <= 1:
		max_health = 1
	else:
		max_health = max_health - value
		if health > max_health:
			health = max_health
	emit_signal("max_health_changed", max_health)
	emit_signal("health_changed", health)

func increase_equipment_attack(value):
	equipment_attack = zero
	equipment_attack += value
	emit_signal("equipment_attack_changed", equipment_attack)

func increase_equipment_hp(value):
	equipment_hp = zero
	equipment_hp += value
	emit_signal("equipment_attack_changed", equipment_hp)

func increment_all_stat():
	total_attack = zero
	total_hp = zero
	total_attack = total_attack + equipment_attack + buff_attack + base_attack
	total_hp = total_hp + equipment_hp + buff_hp + max_health
	emit_signal("total_hp_changed", total_hp)
	emit_signal("total_attack_changed", total_attack)
	
