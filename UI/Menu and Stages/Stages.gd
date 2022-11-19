extends Control

onready var stagemusic = $AudioStreamPlayer

var visualnovel = preload("res://UI/VisualNovel/VisualNovel.tscn").instance()
var scene = PackedScene.new()

func _ready():
	stagemusic.play()

func _on_Stage1Button_pressed():
	visualnovel.dialogue_file = "res://UI/VisualNovel/dialogue text/Stage1.1.txt"
	visualnovel.nextfiledir = "res://World/World.tscn"
	visualnovel.dialogue_music = "res://UI/VisualNovel/Enemy_BGM_VisualNovel.mp3"
	visualnovel.character1 = "res://UI/VisualNovel/KomandanJepang.png"
	visualnovel.character2 = "res://UI/VisualNovel/KomandanSekutu.png"
	visualnovel.BG1 = "res://UI/VisualNovel/RuanganJepangBG.png"
	visualnovel.after_VN = true
	visualnovel.dialogue_file_2 = "res://UI/VisualNovel/dialogue text/Stage1.2.txt"
	visualnovel.dialogue_music_2 = "res://UI/VisualNovel/Ally_BGM_VisualNovel.mp3"
	visualnovel.character1_2 = "res://UI/VisualNovel/PemudaIndonesia1.png"
	visualnovel.character2_2 = "res://UI/VisualNovel/PemudaIndonesia6.png"
	visualnovel.character3_2 = "res://UI/VisualNovel/PemudaIndonesia5.png"
	visualnovel.character4_2 = "res://UI/VisualNovel/PemudaIndonesia3.png"
	visualnovel.BG2 = "res://UI/VisualNovel/perumahan.png"
	get_tree().get_root().add_child(visualnovel)
	queue_free()
	
func _on_TouchScreenButton_pressed():
	get_tree().change_scene("res://UI/Menu and Stages/Menu.tscn")
	queue_free()
