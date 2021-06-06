extends Panel

var default_tex = preload("res://Assets/Theme2/item_bg.png")
var empty_tex = preload("res://Assets/Theme2/item_bg_empty.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://GUI/Inventory/Item.tscn")
var item = null
var slot_index

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

# หยิบขึ้น
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
# วางลง
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()

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
	var children = get_children()
	if children.size() > 0:
		for i in children:
			i.queue_free()
	refresh_style()
