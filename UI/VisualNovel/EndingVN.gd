extends Node

var visualnovel = preload("res://UI/VisualNovel/VisualNovel.tscn").instance()
var globalvar = Global

func stage1bossVNending():
	globalvar.stage2 = true
	globalvar.saveprogress()
	visualnovel.dialogue_file = "res://UI/VisualNovel/dialogue text/Stage1.1ending.txt"
	visualnovel.nextfiledir = "res://UI/Menu and Stages/Stages.tscn"
	visualnovel.dialogue_music = "res://UI/VisualNovel/Riseofspirit.mp3"
	visualnovel.character1 = "res://UI/VisualNovel/PemudaIndonesia1.png"
	visualnovel.character2 = "res://UI/VisualNovel/KomandanJepang.png"
	visualnovel.character3 = "res://UI/VisualNovel/PemudaIndonesia5.png"
	visualnovel.BG1 = "res://UI/VisualNovel/PTTVN.png"
	visualnovel.after_VN = false	
	get_tree().get_root().add_child(visualnovel)
	

func stage2bossVNending():
	globalvar.stage2 = true
	globalvar.saveprogress()
	visualnovel.dialogue_file = "res://UI/VisualNovel/dialogue text/Stage2.1ending.txt"
	visualnovel.nextfiledir = "res://UI/Menu and Stages/Stages.tscn"
	visualnovel.dialogue_music = "res://UI/VisualNovel/Riseofspirit.mp3"
	visualnovel.character1 = "res://UI/VisualNovel/KomandanIndonesia.png"
	visualnovel.character2 = "res://UI/VisualNovel/PemudaIndonesia6.png"
	visualnovel.character4 = "res://UI/VisualNovel/PemudaIndonesia2.png"
	visualnovel.BG1 = "res://UI/VisualNovel/RuanganJepangBG.png"
	visualnovel.after_VN = false	
	get_tree().get_root().add_child(visualnovel)
