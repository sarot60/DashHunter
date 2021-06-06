extends TextureRect

const SlotClass = preload("res://GUI/Inventory/Slot.gd")

func _ready():
	hide()

func initialize_item_detail(slot:SlotClass):
	show()
	$SlotImage.initialize_item(slot.item.item_name, slot.item.item_quantity, slot.item.item_tier)
	#$ItemName.text = slot.item.item_name
	
	var str_info = ""
	
	str_info += slot.item.item_name + "\n"
	
	if JsonData.item_data[slot.item.item_name]["ItemCatagory"] == "Weapon" \
		or JsonData.item_data[slot.item.item_name]["ItemCatagory"] == "Armor" \
		or JsonData.item_data[slot.item.item_name]["ItemCatagory"] == "Shoes" \
		or JsonData.item_data[slot.item.item_name]["ItemCatagory"] == "Shield" \
		or JsonData.item_data[slot.item.item_name]["ItemCatagory"] == "Accessories" \
		or JsonData.item_data[slot.item.item_name]["ItemCatagory"] == "Helmet": \
		
		#$ItemName.text = slot.item.item_name + " +" + str(slot.item.item_tier)
		
		#$ItemLevel.show()
		#$ItemLevel.text = "Item level : " + str(JsonData.item_data[slot.item.item_name]["ItemLevel"])
		
		str_info += "Tier +" + str(slot.item.item_tier) + "\n"
		
		
		
		pass
	else:
		#$ItemLevel.hide()
		pass
	
	str_info += "\nDescription :\n" + JsonData.item_data[slot.item.item_name]["Description"] + "\n"
	
	str_info += "\nStack Size : " + str(JsonData.item_data[slot.item.item_name]["StackSize"]) + "\n"
		
	$RichTextLabel.set_bbcode(str_info) 
