extends Control

onready var inventorycontainer = InventoryContainer
onready var bullet_icon = $BulletIcon
onready var ammo_label = $Ammo
onready var lokasi = $LabelLokasi

func _ready():
	inventorycontainer.inventorySlotDisplay.connect("ammo_changed", self, "refresh_ammo_icon")
	ammo_label.text = str(inventorycontainer.inventorySlotDisplay.find_ammo_items())
	lokasi.text = get_owner().get_owner().nama_tempat
	
func refresh_ammo_icon(ammo):
	#print("refresh_ammo_icon")
	ammo_label.text = str(ammo)
