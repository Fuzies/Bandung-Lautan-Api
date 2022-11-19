extends AnimatedSprite


func _ready():
	self.visible = true
	connect("animation_finished", self, "_on_animation_finished") #connect ke signal jika animasi telah berakhir
	frame = 0
	play("Animasi")

func _on_animation_finished():
	queue_free()

