extends Control


onready var dialoguebox = $Dialogue
onready var dialoguebox_2 = $Dialogue2
onready var sprite1 = $"1/Sprite1"
onready var sprite2 = $"2/Sprite2"
onready var sprite3 = $"3/Sprite3"
onready var sprite4 = $"4/Sprite4"
onready var textureRect = $TextureRect

export(String, FILE, "*.txt") var dialogue_file
export(String, FILE) var nextfiledir #.json atau .tscn
export(String, FILE, "*.mp3") var dialogue_music
export(String, FILE, "*.png") var character1 = null
export(String, FILE, "*.png") var character2 = null
export(String, FILE, "*.png") var character3 = null
export(String, FILE, "*.png") var character4 = null
export(String, FILE, "*.png") var BG1 = null
export var after_VN = false
export(String, FILE, "*.txt") var dialogue_file_2
export(String, FILE) var nextfiledir_2 #.json atau .tscn
export(String, FILE, "*.mp3") var dialogue_music_2
export(String, FILE, "*.png") var character1_2 = null
export(String, FILE, "*.png") var character2_2 = null
export(String, FILE, "*.png") var character3_2 = null
export(String, FILE, "*.png") var character4_2 = null
export(String, FILE, "*.png") var BG2 = null

func _ready():
	if character1 != null:
		sprite1.texture = load(character1)
	if character2 != null:
		sprite2.texture = load(character2)
	if character3 != null:
		sprite3.texture = load(character3)
	if character4 != null:
		sprite4.texture = load(character4)
	if BG1 != null:
		textureRect.texture = load(BG1)
	dialoguebox.dialogue_file = dialogue_file
	if dialogue_music != null:
		dialoguebox.set_and_play_music(dialogue_music)
	dialoguebox.play()
	dialoguebox.connect("dialoguefinished", self,"next_stage_or_world")
	
func next_stage_or_world():
	if !after_VN:
		get_tree().change_scene(nextfiledir)
		queue_free()
	elif after_VN:
		dialogue_file = dialogue_file_2
		dialogue_music = dialogue_music_2
		if character1_2 != null:
			sprite1.texture = load(character1_2)
		if character2_2 != null:
			sprite2.texture = load(character2_2)
		if character3_2 != null:
			sprite3.texture = load(character3_2)
		if character4_2 != null:
			sprite4.texture = load(character4_2)
		after_VN = false
		if BG2 != null:
			textureRect.texture = load(BG2)
		dialoguebox_2.dialogue_file = dialogue_file_2
		if dialogue_music != null:
			dialoguebox_2.set_and_play_music(dialogue_music_2)
		dialoguebox_2.play()
		dialoguebox_2.connect("dialoguefinished", self, "next_world")

func next_world():
	get_tree().change_scene(nextfiledir)
	queue_free()
