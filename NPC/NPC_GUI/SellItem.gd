extends Control

const SlotClass = preload("res://GUI/Inventory/Slot.gd")

onready var inventory_slots = $Bg/BackPack

onready var sell_item_slot = $SellBg/SellSlot

func _ready():
	hide()
	
	var _tmp1 = $SellBg/SellButton.connect("pressed", self, "_on_SellButton_pressed", [sell_item_slot])
	
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		
	initialize_inventory()

func initialize_inventory():
	PlayerInventory.initialize_PlayerInventory()
	
	var slots = inventory_slots.get_children()

	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2])
		else:
			#clear slot
			slots[i].clear()
			
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if slot.item != null:
				sell_item_slot.clear()
				sell_item_slot.initialize_item(slot.item.item_name, slot.item.item_quantity, slot.item.item_tier)
				
				$SellBg/ItemName.text = slot.item.item_name + " x" + str(slot.item.item_quantity)
				
				$SellBg/SellButton.modulate = Color(1, 1, 1, 1)
				$SellBg/SellButton.disabled = false
				
				$SellBg/SellPrice.text = str(JsonData.item_data[slot.item.item_name]["SellPrice"])
				
				sell_item_slot.slot_index = slot.slot_index
				
func clear_popup():
	sell_item_slot.clear()
	$SellBg/SellButton.modulate = Color(1, 1, 1, 0.5)
	$SellBg/SellButton.disabled = true
	$SellBg/ItemName.text = "Please select item fron Backpack"
	$SellBg/SellPrice.text = "0"

func _on_SellButton_pressed(item_for_sell):
	if item_for_sell.item == null: return
	
	PlayerInventory.remove_item_quantity(item_for_sell, 1)
	AddExperience.add_coin(JsonData.item_data[item_for_sell.item.item_name]["SellPrice"])
	# Call to TextAlert.gd
	get_tree().call_group("add_data_to_play", "add_data_to_play", "The item has been sold successfully.")
	
	$sell_and_buy_sfx.play(0)
	
	if PlayerInventory.inventory.has(item_for_sell.slot_index):
		var new_item_name = PlayerInventory.inventory[item_for_sell.slot_index][0]
		var new_item_quantity = PlayerInventory.inventory[item_for_sell.slot_index][1]
		var new_item_tier = PlayerInventory.inventory[item_for_sell.slot_index][2]
		
		$SellBg/ItemName.text = new_item_name + " x" + str(new_item_quantity)
		
		item_for_sell.initialize_item(new_item_name, new_item_quantity, new_item_tier)
	else:
		item_for_sell.clear()
		clear_popup()
		
	initialize_inventory()
