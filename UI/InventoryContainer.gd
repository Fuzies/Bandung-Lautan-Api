extends ColorRect

onready var inventoryDisplay = $CenterContainer/InventoryDisplay
onready var inventorySlotDisplay = $CenterContainer/InventoryDisplay/InventorySlotDisplay
onready var statslabelhp = $StatsLabelHP
onready var statslabelattack = $StatsLabelAttack
onready var itemindex = null
onready var bag_audio = $AudioStreamPlayer
var stats = PlayerStats

func _ready():
	statslabelattack.text = "Serangan : "+str(stats.total_attack)
	statslabelhp.text = "Nyawa : "+str(stats.total_hp)
	stats.connect("total_hp_changed", self,"set_hplabel")
	stats.connect("total_attack_changed", self,"set_atklabel")

func _process(delta):
	if Input.is_action_just_pressed("Inventory") and self.visible == true:
		close_inventory()
	elif Input.is_action_just_pressed("Inventory") and self.visible == false:
		open_inventory()
	if Input.is_action_just_pressed("debug"):
		print("Peluru di inventory :",inventorySlotDisplay.find_ammo_items())
	
func item_picked(item_name):
	inventorySlotDisplay.item_obtained(item_name)

func access_ammo():
	inventorySlotDisplay.find_ammo_items()
func close_inventory():
	bag_audio.stream = load("res://Sound/Effect/bag_close.mp3")
	bag_audio.play()
	self.visible = false
	inventoryDisplay.set_process(false)

func open_inventory():
	bag_audio.stream = load("res://Sound/Effect/bag_open.mp3")
	bag_audio.play()
	self.visible = true
	inventoryDisplay.set_process(true)

func set_hplabel(value):
	statslabelhp.text = "Nyawa : "+str(stats.total_hp)

func set_atklabel(value):
	statslabelattack.text = "Serangan : "+str(stats.total_attack)
