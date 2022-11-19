extends Area2D

onready var analogArea = $AnalogArea
onready var analog = $AnalogArea/Analog

onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

func _input(event):
	if event is InputEventScreenTouch:
		var distance = event.position.distance_to(analogArea.global_position)
		if not touched:
			if distance < max_distance:
				touched = true
		
func _process(delta):
	if touched:
		analog.global_position = get_global_mouse_position()
		analog.position = analogArea.position + (analog.position - analogArea.position).clamped(max_distance)
func get_velocity():
	var joy_velocity = Vector2.ZERO
	joy_velocity.x = analog.position.x / max_distance
	joy_velocity.y = analog.position.y / max_distance
	return joy_velocity

func _unhandled_input(event):
	pass
