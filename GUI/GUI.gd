extends CanvasLayer

var inv_open:bool = false

func _ready():
	# call from inventory.gd
	add_to_group("update_inv")
	
func initialize_GUI():
	pass
	
# Group update_inv / Call from inventory.gd
func update_inv_status(s):
	inv_open = s


func _on_BackpackButton_pressed():
	$Inventory/InventoryPopup.show()
	$Inventory.initialize_inventory()
	$Inventory.initialize_equipment()
	$Inventory.initialize_use_item_slot()
	inv_open = true


func _on_QuestButton_pressed():
	$Inventory/InventoryPopup.hide()
	$Quest.show()
	
	$Quest.initialize_quest_gui()
	$Quest.initialize_quest_popup()


func _on_SkillButton_pressed():
	$Inventory/InventoryPopup.hide()
	$Skill.show()
	
	$Skill.initialize_skill()
	$Skill.initialize_skill_slot()
