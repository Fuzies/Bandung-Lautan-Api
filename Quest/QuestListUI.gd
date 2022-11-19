extends Control

onready var vboxcontainer = $ScrollContainer/VBoxContainer
onready var quest_audio = $AudioStreamPlayer

var questlist = QuestList

func _ready():
	vboxcontainer.add_constant_override("separation", 1)
	questlist.connect("quest_has_been_taken",self ,"add_quest_list")
	questlist.connect("increment_objective", self ,"update_objective_label")
	questlist.connect("quest_has_been_completed", self, "remove_completed_quest")

func _process(delta):
	if Input.is_action_just_pressed("Quest"):
		set_visibility()

func set_visibility():
	quest_audio.play()
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true

func add_quest_list(judul, deskripsi, objektif, max_objektif):
	var font = DynamicFont.new()
	var judul_quest = Label.new()
	var deskripsi_quest = Label.new()
	var jumlah = Label.new()
	var progress = objektif
	var batas_progress = max_objektif
	font.font_data = load("res://UI/Gamer.ttf")
	judul_quest.text = judul
	judul_quest.set("custom_colors/font_color",Color(0,100,0))
	judul_quest.set_align(1)
	judul_quest.set("custom_fonts/font", font)
	vboxcontainer.add_child(judul_quest)
	font.size = 10
	jumlah.text = str(progress) + "/" + str(batas_progress)
	jumlah.set("custom_colors/font_color",Color(255,0,0))
	jumlah.set_align(1)
	jumlah.set("custom_fonts/font", font)
	vboxcontainer.add_child(jumlah)
	deskripsi_quest.set_align(1)
	deskripsi_quest.text = deskripsi
	deskripsi_quest.set("custom_fonts/font", font)
	vboxcontainer.add_child(deskripsi_quest)

func update_objective_label(objective, quest_name, max_obj):
	for i in vboxcontainer.get_child_count():
		if vboxcontainer.get_child(i).text == quest_name:
			var n = i + 1
			vboxcontainer.get_child(n).text = str(objective) + "/" + str(max_obj)
			if objective >= max_obj:
				vboxcontainer.get_child(n).text = str(max_obj) + "/" + str(max_obj)
				vboxcontainer.get_child(n).set("custom_colors/font_color",Color(0,255,0))
	#print(vboxcontainer.get_child_count())

func remove_completed_quest(q_name):
	for i in vboxcontainer.get_child_count():
		if vboxcontainer.get_child(i).text == q_name:
			vboxcontainer.get_child(i).queue_free()
			vboxcontainer.get_child(i+1).queue_free()
			vboxcontainer.get_child(i+2).queue_free()
