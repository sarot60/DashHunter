extends Control

onready var item_panel_object = $ShopItemObject
onready var shop_list = $BG/ScrollContainer/GridContainer

var default_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var warning_color: Color = Color(1.0, 0, 0, 1.0)

func _ready():
	hide()

	var _tmp1 = $BG/CloseButton.connect("pressed", self, "_on_CloseButton_pressed")
	
	if Game.main != null:
		#print(get_parent().get_parent().get_parent().self_npc_type)
		pass
	
	var alchemist_shop_data = JsonData.alchemist_shop_data
	for i in range(alchemist_shop_data.size()):
		var item_panel = item_panel_object.duplicate()
		item_panel.name = str(i)
		shop_list.add_child(item_panel)
		
	var player_coin = game_state.state.coin
	
	var item_panels = shop_list.get_children()
	for i in range(item_panels.size()):
		item_panels[i].get_node("BuyButton").connect("pressed", self, "item_button_pressed", [item_panels[i]])
		var item_img_path = "res://Assets/item_icons/" + JsonData.alchemist_shop_data[i]["item_id"] + ".png"
		item_panels[i].get_node("ItemBg/ItemImage").texture = load(item_img_path)
		item_panels[i].get_node("Name").text = JsonData.alchemist_shop_data[i]["item_id"]
		#item_panels[i].get_node("Price").text = str(JsonData.alchemist_shop_data[i]["price"])
		item_panels[i].get_node("Price").text = str(JsonData.item_data[JsonData.alchemist_shop_data[i]["item_id"]]["BuyPrice"])
		if JsonData.item_data[JsonData.alchemist_shop_data[i]["item_id"]]["BuyPrice"] > player_coin:
			item_panels[i].get_node("Price").set("custom_colors/font_color", warning_color)
		else:
			item_panels[i].get_node("Price").set("custom_colors/font_color", default_color)

func item_button_pressed(item_panel):
	var buy_price = JsonData.item_data[JsonData.alchemist_shop_data[int(item_panel.name)]["item_id"]]["BuyPrice"]

	PlayerInventory.add_item(JsonData.alchemist_shop_data[int(item_panel.name)]["item_id"], 1, 0)
	
	game_state.state.coin -= buy_price
	
	$sell_and_buy_sfx.play(0)
	
	# Call to HealthBar.gd
	get_tree().call_group("update_coin", "update_coin" , self)

	# Call to TextAlert.gd
	get_tree().call_group("add_data_to_play", "add_data_to_play", "Buy Success !!!")

func update_shop_ui():
	var player_coin = game_state.state.coin
	var item_panels = shop_list.get_children()
	for i in range(item_panels.size()):
		var item_img_path = "res://Assets/item_icons/" + JsonData.alchemist_shop_data[i]["item_id"] + ".png"
		item_panels[i].get_node("ItemBg/ItemImage").texture = load(item_img_path)
		item_panels[i].get_node("Name").text = JsonData.alchemist_shop_data[i]["item_id"]
		item_panels[i].get_node("Price").text = str(JsonData.item_data[JsonData.alchemist_shop_data[i]["item_id"]]["BuyPrice"])
		if JsonData.item_data[JsonData.alchemist_shop_data[i]["item_id"]]["BuyPrice"] > player_coin:
			item_panels[i].get_node("Price").set("custom_colors/font_color", warning_color)
		else:
			item_panels[i].get_node("Price").set("custom_colors/font_color", default_color)
	pass
func _on_CloseButton_pressed():
	hide()
