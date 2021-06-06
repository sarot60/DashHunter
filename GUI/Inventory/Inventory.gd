extends CanvasLayer

const SlotClass = preload("res://GUI/Inventory/Slot.gd")
onready var inventory_slots = $InventoryPopup/Backpack
onready var equipment_slots = $InventoryPopup/Equipment
onready var use_item_slots = $UseItem/UseItem
var holding_item = null

var prev_slot = null

""" == my add
"""
var from_slot_type = ""
var to_slot_type = ""
var equipment_slot_ref = {
	0: "Weapon",
	1: "Shield",
	2: "Armor",
	3: "Shoes",
	4: "Helmet",
	5: "Accessories",
	6: "Accessories",
}
""" == my add
"""

func _ready():
	$InventoryPopup.hide()
	
	add_to_group("game_start")
	# call from PlayerStats.gd
	add_to_group("update_player_stats")
	
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		
	var equ_slots = equipment_slots.get_children()
	for i in range(equ_slots.size()):
		equ_slots[i].connect("gui_input", self, "slot_gui_input", [equ_slots[i]])
		equ_slots[i].slot_index = i
		
	var use_itm_slots = use_item_slots.get_children()
	for i in range(use_itm_slots.size()):
		use_itm_slots[i].connect("gui_input", self, "slot_gui_input", [use_itm_slots[i]])
		use_itm_slots[i].slot_index = i
		
	initialize_inventory()
	initialize_equipment()
	initialize_use_item_slot()
	initialize_stats()

# in group game_start
func game_start(_s):
	initialize_inventory()
	initialize_equipment()
	initialize_use_item_slot()
	initialize_stats()

	if holding_item != null:
		holding_item.queue_free()
	if prev_slot != null:
		prev_slot.clear()
	holding_item = null
	prev_slot = null
	
func initialize_stats():
	$InventoryPopup/player_equipment/Level/Label.text = str(game_state.state.level)
	$InventoryPopup/player_equipment/XP/Label.text = str(game_state.state.cur_exp) + "/" + str(game_state.state.req_exp)
	$InventoryPopup/player_equipment/XP/xp_bar_frame_stats/TextureProgress.max_value = game_state.state.req_exp
	$InventoryPopup/player_equipment/XP/xp_bar_frame_stats/TextureProgress.value = game_state.state.cur_exp
	
	#stats
	$InventoryPopup/player_stats_background/hp/Label.text = str(PlayerStats.cur_hp) + "/" + str(PlayerStats.max_hp)
	$InventoryPopup/player_stats_background/mp/Label.text = str(PlayerStats.cur_sp) + "/" + str(PlayerStats.max_sp)
	$InventoryPopup/player_stats_background/stamina/Label.text = str(PlayerStats.cur_stamina) + "/" + str(PlayerStats.max_stamina)
	$InventoryPopup/player_stats_background/damage/Label.text = str(PlayerStats.damage)
	$InventoryPopup/player_stats_background/def/Label.text = str(PlayerStats.defend)
	$InventoryPopup/player_stats_background/speed/Label.text = str(PlayerStats.speed)
	$InventoryPopup/player_stats_background/crit_dmg/Label.text = str(PlayerStats.critical_damage)
	$InventoryPopup/player_stats_background/crit_rate/Label.text = str(PlayerStats.critical_rate)
	
func initialize_inventory():
	#print("inv = ", game_state.state.player_inventory)
	var slots = inventory_slots.get_children()

	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2])
		else:
			#clear slot
			slots[i].clear()
			
	$InventoryPopup/ItemDetail.hide()
	
""" ==== my add
"""
func initialize_equipment():
	# Slot 0 = Weapon
	# Slot 1 = Shield
	# Slot 2 = Armor
	# Slot 3 = Shoes
	# Slot 4 = Helmet
	# Slot 5 = Accessories 1
	# Slot 6 = Accessories 2
	
	#print("euq = ", game_state.state.player_equipment)
	var equ_slots = equipment_slots.get_children()
	
	for i in range(equ_slots.size()):
		if PlayerInventory.equipment.has(i):
			equ_slots[i].initialize_item(PlayerInventory.equipment[i][0], PlayerInventory.equipment[i][1], PlayerInventory.equipment[i][2])
		else:
			#clear slot
			equ_slots[i].clear()
			
func initialize_use_item_slot():
	var use_itm_slots = use_item_slots.get_children()
	
	for i in range(use_itm_slots.size()):
		if PlayerInventory.use_item_slot.has(i):
			use_itm_slots[i].initialize_item(PlayerInventory.use_item_slot[i][0], PlayerInventory.use_item_slot[i][1], PlayerInventory.use_item_slot[i][2])
		else:
			#clear slot
			use_itm_slots[i].clear()
""" ====
"""

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding an Item กำลังถือไอเทมอยู่
			if holding_item != null:
				# Empty slot ช่องว่าง
				if !slot.item:
					left_click_empty_slot(slot)
				# Slot already contains an item ช่องมีรายการอยู่แล้ว
				else:
					# Dufferent item, so swap รายการที่แตกต่างกันดังนั้นแลกเปลี่ยน
					if holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					# Same item, so try to merge รายการเดียวกันดังนั้นพยายามรวม
					else:
						left_click_same_item(slot)
			# Not holding an item ไม่ถือสิ่งของ เมือคลิกก็ทำการถือ
			elif slot.item:
				left_click_not_holding(slot)
				
func _input(_event):
	# ทำการย้ายไอเทมไปตามเมาส์
	if holding_item:
		#holding_item.global_position = $InventoryPopup.get_global_mouse_position()
		holding_item.global_position = get_viewport().get_mouse_position()

# ต้องถือไอเทม -> วางที่ช่องว่าง
func left_click_empty_slot(slot:SlotClass):
	to_slot_type = slot.get_parent().name
	if to_slot_type == "Equipment":
		for i in equipment_slot_ref:
			var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCatagory"] 
			if equipment_slot_ref[slot.slot_index] == holding_item_category:
				#print(holding_item.item_tier)
				PlayerInventory.equ_add_item_to_empty_slot(holding_item, slot)
				slot.putIntoSlot(holding_item)
				holding_item = null
				prev_slot = null
				$InventoryPopup/ItemDetail.hide()
				PlayerStats.calculate_stats(null)
				return
	elif to_slot_type == "Backpack":
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		slot.putIntoSlot(holding_item)
		holding_item = null
		prev_slot = null
		$InventoryPopup/ItemDetail.hide()
	elif to_slot_type == "UseItem":
		PlayerInventory.use_item_slot_add_item_to_empty_slot(holding_item, slot)
		slot.putIntoSlot(holding_item)
		holding_item = null
		prev_slot = null
		$InventoryPopup/ItemDetail.hide()
		
# ต้องถือไอเทม -> ไอเทมที่แตกต่างกันดังนั้นแลกเปลี่ยน 
func left_click_different_item(event:InputEvent, slot:SlotClass):
	to_slot_type = slot.get_parent().name
	if to_slot_type == "Equipment":
		for i in equipment_slot_ref:
			var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCatagory"] 
			if equipment_slot_ref[slot.slot_index] == holding_item_category:
				$InventoryPopup/ItemDetail.initialize_item_detail(slot)
				#print(holding_item.item_tier)
				PlayerInventory.equ_remove_item(slot)
				PlayerInventory.equ_add_item_to_empty_slot(holding_item, slot)
				var temp_item = slot.item 
				slot.pickFromSlot()
				temp_item.global_position = event.global_position
				slot.putIntoSlot(holding_item)
				holding_item = temp_item
				PlayerStats.calculate_stats(null)
				return
	elif to_slot_type == "Backpack":
		$InventoryPopup/ItemDetail.initialize_item_detail(slot)
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(holding_item)
		holding_item = temp_item
	elif to_slot_type == "UseItem":
		$InventoryPopup/ItemDetail.initialize_item_detail(slot)
		PlayerInventory.use_item_slot_remove_item(slot)
		PlayerInventory.use_item_slot_add_item_to_empty_slot(holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(holding_item)
		holding_item = temp_item
		
	
# ต้องถือไอเทม -> ไอเทมเดียวกันดังนั้นพยายามรวม
func left_click_same_item(slot:SlotClass):
	to_slot_type = slot.get_parent().name
	if to_slot_type == "Equipment":
		for i in equipment_slot_ref:
			var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCatagory"] 
			if equipment_slot_ref[slot.slot_index] == holding_item_category:
				var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
				var able_to_add = stack_size - slot.item.item_quantity
				if able_to_add >= holding_item.item_quantity:
					PlayerInventory.equ_add_item_quantity(slot, holding_item.item_quantity)
					slot.item.add_item_quantity(holding_item.item_quantity)
					holding_item.queue_free()
					holding_item = null
					prev_slot = null
					PlayerStats.calculate_stats(null)
				else:
					PlayerInventory.equ_add_item_quantity(slot, able_to_add)
					slot.item.add_item_quantity(able_to_add)
					holding_item.decrease_item_quantity(able_to_add)
					# my add
					var tmp_slot_item_tier = slot.item.item_tier
					var tmp_holding_item_tier = holding_item.item_tier
					PlayerInventory.equ_add_item_tier(slot, tmp_holding_item_tier)
					slot.item.switch_item_tier(tmp_holding_item_tier)
					holding_item.switch_item_tier(tmp_slot_item_tier)
					PlayerStats.calculate_stats(null)
					return
					# ---
	elif to_slot_type == "Backpack":
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
			slot.item.add_item_quantity(holding_item.item_quantity)
			holding_item.queue_free()
			holding_item = null
			prev_slot = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			holding_item.decrease_item_quantity(able_to_add)
			# my add
			var tmp_slot_item_tier = slot.item.item_tier
			var tmp_holding_item_tier = holding_item.item_tier
			PlayerInventory.add_item_tier(slot, tmp_holding_item_tier)
			slot.item.switch_item_tier(tmp_holding_item_tier)
			holding_item.switch_item_tier(tmp_slot_item_tier)
			return
			# ---
	elif to_slot_type == "UseItem":
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= holding_item.item_quantity:
			PlayerInventory.use_item_slot_add_item_quantity(slot, holding_item.item_quantity)
			slot.item.add_item_quantity(holding_item.item_quantity)
			holding_item.queue_free()
			holding_item = null
			prev_slot = null
		else:
			PlayerInventory.use_item_slot_add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			holding_item.decrease_item_quantity(able_to_add)
			
			# my add
			var tmp_slot_item_tier = slot.item.item_tier
			var tmp_holding_item_tier = holding_item.item_tier
			PlayerInventory.use_item_slot_add_item_tier(slot, tmp_holding_item_tier)
			slot.item.switch_item_tier(tmp_holding_item_tier)
			holding_item.switch_item_tier(tmp_slot_item_tier)
			return
			# ---
# ต้องไม่ถือไอเทม -> ทำการถือไอเทม
func left_click_not_holding(slot:SlotClass):
	from_slot_type = slot.get_parent().name
	if from_slot_type == "Equipment":
		$InventoryPopup/ItemDetail.initialize_item_detail(slot)
		PlayerInventory.equ_remove_item(slot)
		holding_item = slot.item
		prev_slot = slot
		slot.pickFromSlot()
		holding_item.global_position = get_viewport().get_mouse_position()
		PlayerStats.calculate_stats(null)
	elif from_slot_type == "Backpack":
		$InventoryPopup/ItemDetail.initialize_item_detail(slot)
		PlayerInventory.remove_item(slot)
		holding_item = slot.item
		prev_slot = slot
		slot.pickFromSlot()
#		holding_item.global_position = $mouse_holding.get_global_mouse_position()
		holding_item.global_position = get_viewport().get_mouse_position()
	elif from_slot_type == "UseItem":
		if get_parent().inv_open:
			$InventoryPopup/ItemDetail.initialize_item_detail(slot)
			PlayerInventory.use_item_slot_remove_item(slot)
			holding_item = slot.item
			prev_slot = slot
			slot.pickFromSlot()
			holding_item.global_position = get_viewport().get_mouse_position()
		else:
			$use_item_sfx.play(0)
			var itm_category = JsonData.item_data[slot.item.item_name]["ItemCatagory"]
			if itm_category == "Consumable":
				if JsonData.item_data[slot.item.item_name].has("HP") and JsonData.item_data[slot.item.item_name].has("SP"):
					var add_hp = JsonData.item_data[slot.item.item_name]["HP"]
					var add_sp = JsonData.item_data[slot.item.item_name]["SP"]
					PlayerInventory.use_item_slot_remove_item_quantity(slot, 1)
					PlayerManageStats.use_hp_potion(add_hp)
					PlayerManageStats.use_sp_potion(add_sp)
					if PlayerInventory.use_item_slot.has(slot.slot_index):
						var new_item_name = PlayerInventory.use_item_slot[slot.slot_index][0]
						var new_item_quantity = PlayerInventory.use_item_slot[slot.slot_index][1]
						var new_item_tier = PlayerInventory.use_item_slot[slot.slot_index][2]

						#slot.item.set_item(new_item_name, new_item_quantity, new_item_tier)
						#slot.item.set_item(slot.item.item_name, slot.item.item_quantity-1, slot.item.item_tier)

						slot.initialize_item(new_item_name, new_item_quantity, new_item_tier)
					else:
						slot.clear()
					return
				if JsonData.item_data[slot.item.item_name].has("HP"):
					var add_hp = JsonData.item_data[slot.item.item_name]["HP"]
					PlayerInventory.use_item_slot_remove_item_quantity(slot, 1)
					PlayerManageStats.use_hp_potion(add_hp)
					if PlayerInventory.use_item_slot.has(slot.slot_index):
						var new_item_name = PlayerInventory.use_item_slot[slot.slot_index][0]
						var new_item_quantity = PlayerInventory.use_item_slot[slot.slot_index][1]
						var new_item_tier = PlayerInventory.use_item_slot[slot.slot_index][2]

						#slot.item.set_item(new_item_name, new_item_quantity, new_item_tier)
						#slot.item.set_item(slot.item.item_name, slot.item.item_quantity-1, slot.item.item_tier)

						slot.initialize_item(new_item_name, new_item_quantity, new_item_tier)
					else:
						slot.clear()
				elif JsonData.item_data[slot.item.item_name].has("SP"):
					var add_sp = JsonData.item_data[slot.item.item_name]["SP"]
					PlayerInventory.use_item_slot_remove_item_quantity(slot, 1)
					PlayerManageStats.use_sp_potion(add_sp)
					if PlayerInventory.use_item_slot.has(slot.slot_index):
						var new_item_name = PlayerInventory.use_item_slot[slot.slot_index][0]
						var new_item_quantity = PlayerInventory.use_item_slot[slot.slot_index][1]
						var new_item_tier = PlayerInventory.use_item_slot[slot.slot_index][2]

						#slot.item.set_item(new_item_name, new_item_quantity, new_item_tier)
						#slot.item.set_item(slot.item.item_name, slot.item.item_quantity-1, slot.item.item_tier)

						slot.initialize_item(new_item_name, new_item_quantity, new_item_tier)
					else:
						slot.clear()
				
# ----------------------------------------------------------------------------

func _on_CloseButton_pressed():
	get_tree().call_group("update_inv", "update_inv_status", false)
	
	if prev_slot != null and holding_item != null:
		
		var prev_slot_type = prev_slot.get_parent().name
		if prev_slot_type == "Equipment":
			PlayerInventory.equ_add_item_to_empty_slot(holding_item, prev_slot)
			prev_slot.putIntoSlot(holding_item)
		elif prev_slot_type == "Backpack":
			PlayerInventory.add_item_to_empty_slot(holding_item, prev_slot)
			prev_slot.putIntoSlot(holding_item)
		elif prev_slot_type == "UseItem":
			PlayerInventory.use_item_slot_add_item_to_empty_slot(holding_item, prev_slot)
			prev_slot.putIntoSlot(holding_item)
		
		holding_item = null
		prev_slot = null
	
	$InventoryPopup.hide()
	
