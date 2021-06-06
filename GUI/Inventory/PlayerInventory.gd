extends Node

const NUM_INVENTORY_SLOTS = 20

const SlotClass = preload("res://GUI/Inventory/Slot.gd")
const ItemClass = preload("res://GUI/Inventory/Item.gd")

#var inventory = {
#	0: ["Iron Sword", 1], #  ---> slot_index: [item_name, item_quantity]
#	1: ["WoodenShortSwordLv1", 1], #  ---> slot_index: [item_name, item_quantity]
#	2: ["Mushroom", 98], #  ---> slot_index: [item_name, item_quantity]
#	3: ["Slime Potion", 45], #  ---> slot_index: [item_name, item_quantity]
#	4: ["Iron Sword", 1],
#	5: ["MintLeaf", 33],
#	6: ["Aloe Vera Leaf", 54],
#	7: ["Basil Leaf", 22],
#	8: ["Tree Branch", 22]
#	5: ["Iron Sword", 1],
#	6: ["Iron Sword", 1],
#	7: ["Iron Sword", 1],
#	8: ["Iron Sword", 1],
#	9: ["Iron Sword", 1],
#	10: ["Iron Sword", 1],
#	11: ["Iron Sword", 1],
#	12: ["Iron Sword", 1],
#	13: ["Iron Sword", 1],
#	14: ["Iron Sword", 1],
#	15: ["Iron Sword", 1],
#	16: ["Iron Sword", 1],
#}

#var equipment = {
#	0: ["Iron Sword", 1], #  ---> slot_index: [item_name, item_quantity]
#	1: ["WoodenShortSwordLv1", 1],
#}


var inventory
var equipment
var use_item_slot

func _ready():
	initialize_PlayerInventory()
	pass

func initialize_PlayerInventory():
	inventory = game_state.state.player_inventory
	equipment = game_state.state.player_equipment
	use_item_slot = game_state.state.player_use_item_slot


func add_item(item_name, item_quantity, item_tier):
	for item in inventory:
		if inventory[item][0] == item_name:
			# TODO: Check if slot is full
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				# myadd
				inventory[item][2] = item_tier
				save_to_game_state()
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
				# myadd
				inventory[item][2] = item_tier
				save_to_game_state()
			
	# item doesn't exist in inventory yet, so add it to an empty slot
	# ไม่มีรายการอยู่ในสินค้าคงคลังดังนั้นให้เพิ่มลงในช่องว่าง
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity, item_tier]
			save_to_game_state()
			return
			
# ----------------------- inventory  ---------------------
func remove_item(slot:SlotClass):
	inventory.erase(slot.slot_index)
	save_to_game_state()

func add_item_to_empty_slot(item:ItemClass, slot:SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity, item.item_tier]
	save_to_game_state()

func add_item_quantity(slot:SlotClass, quantity_to_add:int):
	inventory[slot.slot_index][1] += quantity_to_add
	save_to_game_state()
	
func remove_item_quantity(slot:SlotClass, quantity_to_remove:int):
	inventory[slot.slot_index][1] -= quantity_to_remove
	if inventory[slot.slot_index][1] == 0:
		inventory.erase(slot.slot_index)
	save_to_game_state()

func add_item_tier(slot:SlotClass, tier:int):
	inventory[slot.slot_index][2] = tier
	save_to_game_state()

"""== my add code
"""
# ----------------------- equipment ---------------------
func equ_remove_item(slot:SlotClass):
	equipment.erase(slot.slot_index)
	save_to_game_state()
	
func equ_add_item_to_empty_slot(item:ItemClass, slot:SlotClass):
	equipment[slot.slot_index] = [item.item_name, item.item_quantity, item.item_tier]
	save_to_game_state()

func equ_add_item_quantity(slot:SlotClass, quantity_to_add:int):
	equipment[slot.slot_index][1] += quantity_to_add
	save_to_game_state()
	
func equ_add_item_tier(slot:SlotClass, tier:int):
	equipment[slot.slot_index][2] = tier
	save_to_game_state()
	
# ----------------------- use item slot ---------------------
func use_item_slot_remove_item(slot:SlotClass):
	use_item_slot.erase(slot.slot_index)
	save_to_game_state()
	
func use_item_slot_add_item_to_empty_slot(item:ItemClass, slot:SlotClass):
	use_item_slot[slot.slot_index] = [item.item_name, item.item_quantity, item.item_tier]
	save_to_game_state()

func use_item_slot_add_item_quantity(slot:SlotClass, quantity_to_add:int):
	use_item_slot[slot.slot_index][1] += quantity_to_add
	save_to_game_state()
	
func use_item_slot_remove_item_quantity(slot:SlotClass, quantity_to_add:int):
	use_item_slot[slot.slot_index][1] -= quantity_to_add
	if use_item_slot[slot.slot_index][1] == 0:
		use_item_slot.erase(slot.slot_index)
	save_to_game_state()
	
func use_item_slot_add_item_tier(slot:SlotClass, tier:int):
	use_item_slot[slot.slot_index][2] = tier
	save_to_game_state()
	
func save_to_game_state():
	game_state.state.player_inventory = inventory
	game_state.state.player_equipment = equipment
	game_state.state.player_use_item_slot = use_item_slot
	
"""== my add code
"""
