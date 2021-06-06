extends Control

const SlotClass = preload("res://NPC/NPC_GUI/Slot.gd")

onready var equipment_item_slots = $EquipmentSlotBg/GridContainer

onready var upgrade_item_slot = $UpgradeSlotBg/UpgradeSlot

onready var next_tier = $UpgradeSlotBg/NextTier

var equipment_category_list = ["Weapon", "Armor", "Shield", "Shoes", "Helmet", "Accessories"]

func _ready():
	hide()
	
	#if get_parent().get_parent().get_parent().self_npc_type != "MERCHANT": return
	
	var _tmp1 = $UpgradeSlotBg/UpgradeButton.connect("pressed", self, "_on_UpgradeButton_pressed", [upgrade_item_slot])
	$UpgradeSlotBg/UpgradeButton.modulate = Color(1, 1, 1, 0.5)
	$UpgradeSlotBg/UpgradeButton.disabled = true
	
	var slots = equipment_item_slots.get_children()
	#if get_parent().get_parent().name == "NPC_Jacob":
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	initialize_item()
	
func initialize_item():
	var slots = equipment_item_slots.get_children()
	
	for i in range(slots.size()):
		slots[i].clear()
	
	var cur_index = 0
	
	PlayerInventory.initialize_PlayerInventory()
	
	# get equ
	for i in range(7):
		if PlayerInventory.equipment.has(i):
			slots[cur_index].initialize_item(game_state.state.player_equipment[i][0], \
			 game_state.state.player_equipment[i][1], game_state.state.player_equipment[i][2])
			slots[cur_index].from_slot_type = "Equipment"
			slots[cur_index].slot_index_in_inventory = i
			cur_index += 1

	# get inventory
	for i in range(20):
		if PlayerInventory.inventory.has(i):
			slots[cur_index].initialize_item(game_state.state.player_inventory[i][0], \
			 game_state.state.player_inventory[i][1], game_state.state.player_inventory[i][2])
			slots[cur_index].from_slot_type = "Backpack"
			slots[cur_index].slot_index_in_inventory = i
			cur_index += 1

	# get use item
	for i in range(5):
		if PlayerInventory.use_item_slot.has(i):
			slots[cur_index].initialize_item(game_state.state.player_use_item_slot[i][0], \
			 game_state.state.player_use_item_slot[i][1], game_state.state.player_use_item_slot[i][2])
			slots[cur_index].from_slot_type = "UseItem"
			slots[cur_index].slot_index_in_inventory = i
			cur_index += 1

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if slot.item != null:
				
				var from_tier 
				var to_tier
				
				var item_data = JsonData.item_data
				if slot.from_slot_type == "Equipment":
					var item_id = game_state.state.player_equipment[int(slot.slot_index_in_inventory)][0]
					if !equipment_category_list.has(item_data[item_id]["ItemCatagory"]):
						return
					else:
						from_tier = game_state.state.player_equipment[int(slot.slot_index_in_inventory)][2]
						to_tier = from_tier + 1
				elif slot.from_slot_type == "Backpack":
					var item_id = game_state.state.player_inventory[int(slot.slot_index_in_inventory)][0]
					if !equipment_category_list.has(item_data[item_id]["ItemCatagory"]):
						return
					else:
						from_tier = game_state.state.player_inventory[int(slot.slot_index_in_inventory)][2]
						to_tier = from_tier + 1
				elif slot.from_slot_type == "UseItem":
					var item_id = game_state.state.player_use_item_slot[int(slot.slot_index_in_inventory)][0]
					if !equipment_category_list.has(item_data[item_id]["ItemCatagory"]):
						return
					else:
						from_tier = game_state.state.player_use_item_slot[int(slot.slot_index_in_inventory)][2]
						to_tier = from_tier + 1
					
				upgrade_item_slot.clear()
				upgrade_item_slot.initialize_item(slot.item.item_name, slot.item.item_quantity, slot.item.item_tier)
				upgrade_item_slot.from_slot_type = slot.from_slot_type
				upgrade_item_slot.slot_index_in_inventory = slot.slot_index_in_inventory
				
				if from_tier >= 10:
					next_tier.get_node("FromTier").text = "+" + str(from_tier)
					next_tier.get_node("ToTier").text = "MAX"
					
					$UpgradeSlotBg/UpgradeButton.modulate = Color(1, 1, 1, 0.5)
					$UpgradeSlotBg/UpgradeButton.disabled = true
				else:
					next_tier.get_node("FromTier").text = "+" + str(from_tier)
					next_tier.get_node("ToTier").text = "+" + str(to_tier)
					
					var price = PlayerStats.price_to_next_upgrade[to_tier]
					$UpgradeSlotBg/UpgradePrice.text = str(price)
					if game_state.state.coin < price:
						$UpgradeSlotBg/UpgradeButton.modulate = Color(1, 1, 1, 0.5)
						$UpgradeSlotBg/UpgradeButton.disabled = true
					else:
						$UpgradeSlotBg/UpgradeButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
						$UpgradeSlotBg/UpgradeButton.disabled = false

func clear_popup():
	upgrade_item_slot.clear()
	$UpgradeSlotBg/UpgradeButton.modulate = Color(1, 1, 1, 0.5)
	$UpgradeSlotBg/UpgradeButton.disabled = true
	next_tier.get_node("FromTier").text = "+0"
	next_tier.get_node("ToTier").text = "+0"
	
	$UpgradeSlotBg/UpgradePrice.text = "0"

func _on_UpgradeButton_pressed(item_to_upgrade):
	if item_to_upgrade.item == null: return
	
	var from_tier
	var to_tier
	
	if item_to_upgrade.from_slot_type == "Equipment":
		var current_tier = game_state.state.player_equipment[int(item_to_upgrade.slot_index_in_inventory)][2]
		var new_tier = current_tier + 1
		game_state.state.player_equipment[int(item_to_upgrade.slot_index_in_inventory)][2] = new_tier
		from_tier = new_tier
		to_tier = new_tier + 1
	elif item_to_upgrade.from_slot_type == "Backpack":
		var current_tier = game_state.state.player_inventory[int(item_to_upgrade.slot_index_in_inventory)][2]
		var new_tier = current_tier + 1
		game_state.state.player_inventory[int(item_to_upgrade.slot_index_in_inventory)][2] = new_tier
		from_tier = new_tier
		to_tier = new_tier + 1
	elif item_to_upgrade.from_slot_type == "UseItem":
		var current_tier = game_state.state.player_use_item_slot[int(item_to_upgrade.slot_index_in_inventory)][2]
		var new_tier = current_tier + 1
		game_state.state.player_use_item_slot[int(item_to_upgrade.slot_index_in_inventory)][2] = new_tier
		from_tier = new_tier
		to_tier = new_tier + 1
		
	var upgrade_to_tier_price = PlayerStats.price_to_next_upgrade[from_tier]
	game_state.state.coin -= upgrade_to_tier_price
	# Call to HealthBar.gd
	get_tree().call_group("update_coin", "update_coin" , self)
	
	if from_tier >= 10:
		next_tier.get_node("FromTier").text = "+" + str(from_tier)
		next_tier.get_node("ToTier").text = "MAX"
		
		$UpgradeSlotBg/UpgradePrice.text = "0"
		
		$UpgradeSlotBg/UpgradeButton.modulate = Color(1, 1, 1, 0.5)
		$UpgradeSlotBg/UpgradeButton.disabled = true
	else:
		item_to_upgrade.initialize_item(item_to_upgrade.item.item_name, item_to_upgrade.item.item_quantity, from_tier)
		
		next_tier.get_node("FromTier").text = "+" + str(from_tier)
		next_tier.get_node("ToTier").text = "+" + str(to_tier)
		
		var price = PlayerStats.price_to_next_upgrade[to_tier]
		$UpgradeSlotBg/UpgradePrice.text = str(price)
		if game_state.state.coin < price:
			$UpgradeSlotBg/UpgradeButton.modulate = Color(1, 1, 1, 0.5)
			$UpgradeSlotBg/UpgradeButton.disabled = true
		else:
			$UpgradeSlotBg/UpgradeButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$UpgradeSlotBg/UpgradeButton.disabled = false
	
	initialize_item()
	
	# Call to PlayerStats.gd
	get_tree().call_group("calculate_stats", "calculate_stats", self)
