extends TouchScreenButton

onready var stat = PlayerStats

func _ready():
	stat.connect("death", self, "Hide")

func Hide():
	visible = false
