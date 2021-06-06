extends Node2D

var item_name
var item_quantity # ปริมาณ
var item_tier # ระดับ

var equipment_category_list = ["Weapon", "Armor", "Shield", "Shoes", "Helmet", "Accessories"]

func _ready():

#	var rand_val = randi() % 3
#	if rand_val == 0:
#		item_name = "Iron Sword"
#	elif rand_val == 1:
#		item_name = "Tree Branch"
#	elif rand_val == 2:
#		item_name = "Slime Potion"
		
#	$TextureRect.texture = load("res://Assets/Theme2/item_icons/" + item_name + ".png")
#	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
#
#	if stack_size == 1:
#		$Label.hide()
#		#$Label.visible = false
#	else:
#		$Label.text = str(item_quantity)
	pass

func set_item(nm, qt, it):
	item_name = nm
	item_quantity = qt
	item_tier = it
	$TextureRect.texture = load("res://Assets/item_icons/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.hide()
	else:
		$Label.show()
		$Label.text = str(item_quantity)
		
	var item_category = JsonData.item_data[item_name]["ItemCatagory"]
	if item_category in equipment_category_list:
		if item_tier != 0:
			$TierText.show()
			$TierText.text = "+" + str(item_tier)
		else:
			$TierText.hide()
	else:
		$TierText.hide()

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
	
func switch_item_tier(tier_amount):
	item_tier = tier_amount
	if item_tier != 0:
		$TierText.show()
		$TierText.text = "+" + str(item_tier)
	else:
		$TierText.hide()
