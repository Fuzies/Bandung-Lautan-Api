extends Control

export(String, FILE, "*.txt") var tutorial_file

onready var vboxcontainer = $VBoxContainer
onready var judul = $JudulLabel
onready var pahambutton = $ConfirmButton
onready var nextbutton = $NextButton
onready var backbutton = $BackButton
onready var dim = $Dim
onready var image = $TutorialImage
onready var textbg = $ColorRect
onready var texttutorial = $ColorRect/TextTutorial

var tutorial_finished = true
var tutorial_count = 0
var tutorial_count_max = 0
var image_url = "res://UI/Item/404.png"
var texts = ""

func _on_ButtonPergerakan_pressed():
	self.tutorial_running(3,"res://UI/Tutorial/Gambar/gerak.png","res://UI/Tutorial/Text/Pergerakan.txt")
	judul.text = "Cara Pergerakan Karakter"
	play_sound()
	
func _on_ButtonPertarungan_pressed():
	judul.text = "Cara Bertarung"
	self.tutorial_running(3,"res://UI/Tutorial/Gambar/serang.png","res://UI/Tutorial/Text/Pertarungan.txt")
	play_sound()
	
func _on_ButtonQuest_pressed():
	judul.text = "Cara Menjalankan Quest"
	self.tutorial_running(2,"res://UI/Tutorial/Gambar/quest.png","res://UI/Tutorial/Text/Quest.txt")
	play_sound()

func _on_ButtonInteraksi_pressed():
	judul.text = "Cara Berinterasksi"
	self.tutorial_running(2,"res://UI/Tutorial/Gambar/interaksi.png","res://UI/Tutorial/Text/Interaksi.txt")
	play_sound()

func _on_ButtonInventory_pressed():
	judul.text = "Cara Menggunakan Inventory"
	self.tutorial_running(4,"res://UI/Tutorial/Gambar/inventory.png","res://UI/Tutorial/Text/Inventory.txt")
	play_sound()

func _on_MenuButton_pressed():
	get_tree().change_scene("res://UI/Menu and Stages/Menu.tscn")

func _on_ConfirmButton_pressed():
	tutorial_finished = true
	vboxcontainer.visible = true
	judul.text = "Cara Bermain"
	pahambutton.visible = false
	nextbutton.visible = false
	backbutton.visible = false
	dim.visible = false
	tutorial_count = 0
	image.visible = false
	textbg.visible = false

func tutorial_running(max_count,url,texturl):
	tutorial_file = texturl
	texts = load_text()
	tutorial_count = 0
	vboxcontainer.visible = false
	tutorial_finished = false
	pahambutton.visible = true
	dim.visible = true
	tutorial_count_max = max_count
	checktutorialbutton()
	image.visible = true
	textbg.visible = true
	image_url = url
	image.texture = load(url)

func _on_BackButton_pressed():
	$Sound2.play()
	if tutorial_count >= 0:
		tutorial_count -= 1
	checktutorialbutton()
	#print("current :",tutorial_count)
	#print("max :",tutorial_count_max)

func _on_NextButton_pressed():
	$Sound2.play()
	if tutorial_count <= tutorial_count_max:
		tutorial_count += 1
	checktutorialbutton()
	#print("current :",tutorial_count)
	#print("max :",tutorial_count_max)

func checktutorialbutton():
	if tutorial_count <= 0:
		$BackButton.visible = false
	else:
		$BackButton.visible = true
	if tutorial_count >= tutorial_count_max:
		$NextButton.visible = false
	else:
		$NextButton.visible = true
	if tutorial_count != 0:
		var tempurl = image_url.insert(image_url.length()-4,str(tutorial_count))
		image.texture = load(tempurl)
		#print(tempurl)
	else:
		image.texture = load(image_url)
	show_text()

func load_text():
	var file = File.new()
	if file.file_exists(tutorial_file):
		file.open(tutorial_file, file.READ)
		return parse_json(file.get_as_text())
	else:
		print("file txt doesnt exist")

func show_text():
	if tutorial_count >= len(texts):
		return
	texttutorial.text = texts[tutorial_count]['text']

func play_sound():
	$Sound.playing = true
