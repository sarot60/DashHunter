extends Control

onready var item_panel_object = $ShopItemObject
onready var shop_list = $BG/ScrollContainer/GridContainer

var default_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var warning_color: Color = Color(1.0, 0, 0, 1.0)

var blacksmith_shop_data: Dictionary = {}

func _ready():
	hide()

	var _tmp1 = $BG/CloseButton.connect("pressed", self, "_on_CloseButton_pressed")
	
	if Game.main != null:
		#print(get_parent().get_parent().get_parent().self_npc_type)
		pass
		
	blacksmith_shop_data = {}
	var index = 0
	for i in JsonData.item_data:
		if JsonData.item_data[i]["ItemCatagory"] == "Weapon":
			blacksmith_shop_data[index] = { "item_id": i, "data": JsonData.item_data[i]}
			index += 1

	#var blacksmith_shop_data = JsonData.blacksmith_shop_data
	for i in range(blacksmith_shop_data.size()):
	#for i in blacksmith_shop_data:
		var item_panel = item_panel_object.duplicate()
		item_panel.name = str(i)
		shop_list.add_child(item_panel)
		
	var player_coin = game_state.state.coin
	
	var item_panels = shop_list.get_children()
	#for i in range(item_panels.size()):
	for i in blacksmith_shop_data.size():
		item_panels[i].get_node("BuyButton").connect("pressed", self, "item_button_pressed", [item_panels[i]])
		#var item_img_path = "res://Assets/item_icons/" + JsonData.blacksmith_shop_data[i]["item_id"] + ".png"
		var item_img_path = "res://Assets/item_icons/" + blacksmith_shop_data[i]["item_id"] + ".png"
		item_panels[i].get_node("ItemBg/ItemImage").texture = load(item_img_path)
		item_panels[i].get_node("Name").text = blacksmith_shop_data[i]["item_id"]
		item_panels[i].get_node("Price").text = str(blacksmith_shop_data[i]["data"]["BuyPrice"])
		if blacksmith_shop_data[i]["data"]["BuyPrice"] > player_coin:
			item_panels[i].get_node("Price").set("custom_colors/font_color", warning_color)
			item_panels[i].get_node("BuyButton").modulate = Color(1, 1, 1, 0.5)
			item_panels[i].get_node("BuyButton").disabled = true
		else:
			item_panels[i].get_node("Price").set("custom_colors/font_color", default_color)
			item_panels[i].get_node("BuyButton").modulate = Color(1, 1, 1, 1)
			item_panels[i].get_node("BuyButton").disabled = false

func item_button_pressed(item_panel):
	#print(game_state.state.coin)
	
	var buy_price = blacksmith_shop_data[int(item_panel.name)]["data"]["BuyPrice"]

	#print(item_panel.name)
	#print(blacksmith_shop_data[int(item_panel.name)])
	
	PlayerInventory.add_item(blacksmith_shop_data[int(item_panel.name)]["item_id"], 1, 0)
	
	$sell_and_buy_sfx.play(0)
	
	game_state.state.coin -= buy_price
	# Call to HealthBar.gd
	get_tree().call_group("update_coin", "update_coin" , self)
	
	# Call to TextAlert.gd
	get_tree().call_group("add_data_to_play", "add_data_to_play", "Buy Success !!!")
	

func update_shop_ui():
	var player_coin = game_state.state.coin
	var item_panels = shop_list.get_children()
	for i in range(item_panels.size()):
		var item_img_path = "res://Assets/item_icons/" + blacksmith_shop_data[i]["item_id"] + ".png"
		item_panels[i].get_node("ItemBg/ItemImage").texture = load(item_img_path)
		item_panels[i].get_node("Name").text = blacksmith_shop_data[i]["item_id"]
		item_panels[i].get_node("Price").text = str(blacksmith_shop_data[i]["data"]["BuyPrice"])
		if blacksmith_shop_data[i]["data"]["BuyPrice"] > player_coin:
			item_panels[i].get_node("Price").set("custom_colors/font_color", warning_color)
			item_panels[i].get_node("BuyButton").modulate = Color(1, 1, 1, 0.5)
			item_panels[i].get_node("BuyButton").disabled = true
		else:
			item_panels[i].get_node("Price").set("custom_colors/font_color", default_color)
			item_panels[i].get_node("BuyButton").modulate = Color(1, 1, 1, 1)
			item_panels[i].get_node("BuyButton").disabled = false
	
func _on_CloseButton_pressed():
	hide()
