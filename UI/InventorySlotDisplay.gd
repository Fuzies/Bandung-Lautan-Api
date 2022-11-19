extends CenterContainer

var inventory = preload("res://UI/Inventory.tres")

export var Emptyslottexture = "res://UI/SlotInventory.png"


onready var stats = PlayerStats
onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel

signal ammo_changed(ammo)

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		itemAmountLabel.text = str(item.amount)
	else:
		itemTextureRect.texture = load(Emptyslottexture)
		itemAmountLabel.text = ""
		

func get_drag_data(position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data 

func can_drop_data(position, data):
	return data is Dictionary and data.has("item")

func drop_data(position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.name == data.item.name and my_item.amount < my_item.max_amount and data.item.amount + my_item.amount <= data.item.max_amount:
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		if my_item_index in [0] and data.item.type != "Hat":
			#print("Dilarang, Tipe item bukan Hat! ", data.item.name)
			inventory.set_item(data.item_index, data.item)
		elif my_item_index in [6] and data.item.type != "Clothes":
			#print("Dilarang, Tipe item bukan Clothes! ", data.item.name)
			inventory.set_item(data.item_index, data.item)
		elif my_item_index in [12] and data.item.type != "Pants":
			#print("Dilarang, Tipe item bukan Pants! ", data.item.name)
			inventory.set_item(data.item_index, data.item)
		elif my_item_index in [18] and data.item.type != "Shoes":
			#print("Dilarang, Tipe item bukan Shoes! ", data.item.name)
			inventory.set_item(data.item_index, data.item)
		elif my_item_index in [1] and data.item.type != "Weapon" and data.item.type != "Gun":
			#print("Dilarang, Tipe item bukan Weapon/Gun! ", data.item.name)
			inventory.set_item(data.item_index, data.item)
		elif my_item_index in [7, 13, 19] and data.item.type != "Accessory":
			#print("Dilarang, Tipe item bukan Accessory! ", data.item.name)
			inventory.set_item(data.item_index, data.item)
		else:
			if data.item_index in [0, 1, 6, 7, 12, 13, 18, 19]:
				if my_item != null:
					if my_item.type != data.item.type:
						inventory.set_item(data.item_index, data.item)
					else:
						inventory.swap_items(my_item_index, data.item_index)
						inventory.set_item(my_item_index, data.item)
				else:
					inventory.set_item(my_item_index, data.item)
			else:
				if my_item_index == data.item_index and data.item.type == "Consumables" :
					if data.item_index >= 1:
						stats.heal(data.item.heal)
						data.item.amount -= 1
						if data.item.amount >= 1:
							inventory.set_item(my_item_index, data.item)
					else:
						data.item.amount = 0
				else:
					inventory.swap_items(my_item_index, data.item_index)
					inventory.set_item(my_item_index, data.item)
			refresh_equipped_items_stats()
	inventory.drag_data = null

func item_obtained(item_name):
	var item = null
	var i: int = 0
	while i <= inventory.items.size():
		var check = false
		if i >= inventory.items.size():
			insert_item_in_new_slot(item_name)
			break
		item = inventory.items[i]
		if item != null:	
			if item.name == item_name and item.amount + 1 <= item.max_amount:
				item.amount += 1
				inventory.emit_signal("items_changed", [i])
				check = true
		if check == true:
			break
		else:
			i += 1
			if i >= inventory.items.size():
				insert_item_in_new_slot(item_name)
				break
	find_ammo_items()
	
func insert_item_in_new_slot(item_name):
	var items = null
	var i: int = 0
	var check2 = false
	while i <= inventory.items.size():
		items = inventory.items[i]
		if items == null and !i in [0, 6, 12, 18, 1, 7, 13, 19] and item_name != "":
			var path = load("res://UI/Item/"+item_name+".tres")
			inventory.items[i] = path.duplicate()
			inventory.emit_signal("items_changed", [i])
			break
		i += 1
		if i >= inventory.items.size():
			print("Tas Penuh!")
			break
			
func refresh_equipped_items_stats():
	var total_equip_atk = 0
	var total_equip_hp = 0
	var stat = PlayerStats
	for i in inventory.items.size():
		if i in [0, 6, 12, 18, 1, 7, 13, 19] and inventory.items[i] != null:
			total_equip_atk += inventory.items[i].attack
			total_equip_hp += inventory.items[i].hp_bonus
	stat.increase_equipment_attack(total_equip_atk)
	stat.increase_equipment_hp(total_equip_hp)
	stat.increment_all_stat()

func find_ammo_items():
	var total_ammo = 0
	for i in inventory.items.size():
		if inventory.items[i] != null and inventory.items[i].type == "Ammunition":
			total_ammo = total_ammo + inventory.items[i].amount
	#print("find_ammo_items", total_ammo)
	emit_signal("ammo_changed", total_ammo)
	return total_ammo

func decrease_ammo():
	var decrement = false
	var total_ammo = 0
	for i in inventory.items.size():
		if inventory.items[i] != null and inventory.items[i].type == "Ammunition":
			total_ammo = total_ammo + inventory.items[i].amount
			if !decrement:
				inventory.items[i].amount -= 1 # -=1
				if inventory.items[i].amount == 0:
					inventory.items[i] = null
			decrement = true
			inventory.emit_signal("items_changed",[i])
	#print("find_ammo_items", total_ammo)
	if total_ammo > 0:
		total_ammo = total_ammo - 1 
	emit_signal("ammo_changed", total_ammo)

func check_hand_weapon():
	if inventory.items[1] != null:
		if inventory.items[1].type == "Gun":
			return true
		else:
			return false

func check_available_ammo():
	var ammo_available = false
	for i in inventory.items.size():
		if inventory.items[i] != null and inventory.items[i].type == "Ammunition":
			if inventory.items[i].amount >= 0:
				ammo_available = true
	return ammo_available
