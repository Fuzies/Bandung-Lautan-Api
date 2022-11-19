extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file

var dialogue = []
var current_dialogue_id = 0
var is_dialogue_active = false
var reveal_speed = 25
var music_path = null

onready var ninePatchRect = $NinePatchRect
onready var dialoguename = $NinePatchRect/Name
onready var dialoguename2 = $NinePatchRect/Name2
onready var dialoguetext = $NinePatchRect/Dialogue
onready var timer = $Timer
onready var nextDialogueButton = $NinePatchRect/NextDialogueButton
onready var reveal_tween = $Tween
onready var dialogue_beep = $AudioStreamPlayer
onready var dialogue_music = $AudioStreamPlayer2

signal dialoguefinished
signal text_display_finished

func _ready():
	ninePatchRect.visible = false
	connect("dialoguefinished",self,"stop_beep")
	connect("text_display_finished",self,"stop_beep")

func play():
	if is_dialogue_active:
		#print(is_dialogue_active)
		return
	
	dialogue = load_dialogue()
	get_tree().paused = true
	is_dialogue_active = true
	ninePatchRect.visible = true
	nextDialogueButton = true
	current_dialogue_id = -1
	next_line()
	

func _input(event):
	if !is_dialogue_active:
		return
	
	if event.is_action_pressed("Interract"):
		next_line()

func next_line():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		timer.start()
		ninePatchRect.visible = false
		get_tree().paused = false
		emit_signal("dialoguefinished")
		stop_beep()
		stop_music()
		return
	if dialogue[current_dialogue_id]['pos'] == 1:
		dialoguename.visible = true
		dialoguename2.visible = false
		dialoguename.text = dialogue[current_dialogue_id]['name']
		dialoguetext.text = dialogue[current_dialogue_id]['text']
	elif dialogue[current_dialogue_id]['pos'] == 2:
		dialoguename2.visible = true
		dialoguename.visible = false
		dialoguename2.text = dialogue[current_dialogue_id]['name']
		dialoguetext.text = dialogue[current_dialogue_id]['text']
		
	#dialoguename.text = dialogue[current_dialogue_id]['name']
	#dialoguetext.text = dialogue[current_dialogue_id]['text']
	set_text_display(dialogue[current_dialogue_id]['text'])
	
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
	else:
		print("file json doesnt exist")

func _on_Timer_timeout():
	dialogue_beep.stream_paused = true
	dialogue_beep.stop()
	is_dialogue_active = false
	
func set_text_display(text):
	dialogue_beep.stream_paused = false
	dialogue_beep.play()
	dialoguetext.text = text
	dialoguetext.percent_visible = 0
	
	var time = dialoguetext.text.length() / reveal_speed
	#print(time)
	if time == 0:
		time += 1
	reveal_tween.interpolate_property(dialoguetext, "percent_visible", 0, 1, time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	reveal_tween.start()
	yield(reveal_tween,"tween_all_completed")
	emit_signal("text_display_finished")
	stop_beep()

func stop_beep():
	dialogue_beep.stream_paused = true

func set_and_play_music(music_path):
	dialogue_music.stream_paused = false
	var sfx = null
	sfx = load(music_path) 
	sfx.set_loop(true)
	dialogue_music.stream = sfx
	#dialogue_music.volume_db = -10
	dialogue_music.play()

func stop_music():
	dialogue_music.stream_paused = true
