extends GridContainer

var inventory = preload("res://UI/Inventory.tres")
var inventorySlot = preload("res://UI/InventorySlotDisplay.tscn").instance()
var deleteitem = false
var duplication_process = 0

func _ready():
	inventory.connect("items_changed",self ,"_on_items_changed")
	inventory.make_items_unique()
	update_inventory_display()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)
 
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func _unhandled_input(event):
	if event.is_action_released("mouse_left"):
		if inventory.drag_data is Dictionary:
			get_child(inventory.drag_data.item_index).find_ammo_items()
			inventory.emit_signal("items_changed", inventory.drag_data.item_index)
			#inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
			pass #item hilang ketika keluar inventory
