extends Panel

var default_tex = preload("res://Assets/AssetForNPC/Blacksmith/item_upgrade_bg.png")
var empty_tex = preload("res://Assets/AssetForNPC/Blacksmith/item_upgrade_bg_empty.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://GUI/Inventory/Item.tscn")
var item = null
var slot_index

var equipment_category_list = ["Weapon", "Armor", "Shield", "Shoes", "Helmet", "Accessories"]

""" my add
"""
var slot_index_in_inventory:int = -1
var from_slot_type:String = ""

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
		
	refresh_style()
	
	
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
		
		var item_data = JsonData.item_data
		if equipment_category_list.has(item_data[item.item_name]["ItemCatagory"]):
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(1, 1, 1, 0.3)
		
func initialize_item(item_name, item_quantity, item_tier):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity, item_tier)
	else:
		item.set_item(item_name, item_quantity, item_tier)
	refresh_style()
	
func clear():
	item = null
	slot_index_in_inventory = -1
	from_slot_type = ""
	var children = get_children()
	if children.size() > 0:
		for i in children:
			i.queue_free()
	refresh_style()
