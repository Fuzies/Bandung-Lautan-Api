extends Control

onready var health_over = $HealthOver
onready var health_under = $HealthUnder
onready var update_tween = $UpdateTween
onready var hplabel = $HealthUnder/HPlabel

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2

var health_ui = 50 setget set_health
var max_health_ui = 100 setget set_max_health

func set_health(value):
	health_ui = clamp(value, 0 , max_health_ui)
	if health_over != null:
		health_over.value = health_under.value
	if health_under != null:
		health_under.value = health_ui
	update_tween.interpolate_property(health_over, "value", health_under.value, health_under.value, 0.1,Tween.TRANS_SINE,Tween.EASE_IN_OUT,1.5)
	update_tween.start()
	hplabel.text = str(health_under.value)+" / "+str(PlayerStats.total_hp)
	_assign_color(health_under.value)

func _assign_color(health):
	if health < health_under.max_value * danger_zone:
		health_under.tint_progress = danger_color
	elif health < health_under.max_value * caution_zone:
		health_under.tint_progress = caution_color
	else:
		health_under.tint_progress = healthy_color
		
func set_max_health(value):
	max_health_ui = max(value, 1)
	if health_under != null:
		health_under.max_value = max_health_ui
		health_over.max_value = max_health_ui
	hplabel.text = str(health_under.value)+" / "+str(max_health_ui)
	_assign_color(health_under.value)

func _ready():
	self.max_health_ui = PlayerStats.total_hp
	self.health_ui = PlayerStats.health
	
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("total_hp_changed", self,"set_max_health")
