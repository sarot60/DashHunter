extends Area2D

#var herb_name:String = ""

var herb_pick_popup = preload("res://Props/HerbPlant/HerbPickPopup.tscn")

var herb_item_ref = {
	"AloeVeraPlant": "Aloe Vera Leaf",
	"MintPlant": "Mint Leaf",
	"BasilPlant": "Basil Leaf",
	"CissusQuadrangularisPlant": "Cissus Quadrangularis",
	"GarlicPlant": "Garlic",
	"GingerPlant": "Ginger",
	"LavenderPlant": "Lavender",
	"LemonGrassPlant": "Lemon Grass",
	"RedOnionPlant": "Red Onion",
	"TurmericPlant": "Turmeric"
}

export(String,
"", 
"AloeVeraPlant",
"MintPlant",
"BasilPlant",
"CissusQuadrangularisPlant",
"GarlicPlant",
"GingerPlant",
"LavenderPlant",
"LemonGrassPlant",
"RedOnionPlant",
"TurmericPlant"
) var herb_name


func _ready():
	
	if herb_name == "": return
	
	#self.herb_name = name
	
	var _tmp1 = connect("body_entered", self, "_on_Plant_body_entered")
	var _tmp2 = connect("body_exited", self, "_on_Plant_body_exited")
	
	if !has_node("HerbPickPopup"):
		var popup:Object = herb_pick_popup.instance()
		popup.get_node("Panel").hide()
		
		var herb_data:Dictionary = JsonGameMetaData.herb_plant[herb_name]

		var strInfo:String = ""
		for i in herb_data["herb_benefits"]:
			strInfo = strInfo + String(int(i)+1) + ". " + String(herb_data["herb_benefits"][i]) + "\n"
		
		popup.get_node("Panel/HerbName").text = herb_name
		popup.get_node("Panel/RichTextLabel").text = strInfo
		
		popup.get_node("Panel/ItemDropBg/Sprite").texture = load("res://Assets/item_icons/"+ herb_item_ref[herb_name] + ".png")
		
		popup.get_node("Panel/Pick").connect("pressed", self, "_on_Pick_pressed")
		popup.get_node("Panel/Cancle").connect("pressed", self, "_on_Cancle_pressed")
		
		add_child(popup)

# ------------- Signals ----------------
func _on_Plant_body_entered(body):
	if body.name == "Player" or body.name == "Player3" or body.name == "Player2":
		if has_node("HerbPickPopup"):
			get_node("HerbPickPopup/Panel").show()

func _on_Plant_body_exited(body):
	if body.name == "Player" or body.name == "Player3" or body.name == "Player2":
		if has_node("HerbPickPopup"):
			get_node("HerbPickPopup/Panel").hide()

func _on_Pick_pressed():
	#game_state.state.current_quest_success = true
	#get_tree().call_group("accept_reward", "check_accept_reward", true)
	
	PlayerInventory.add_item(herb_item_ref[herb_name], 5, 0)
	
	queue_free()
	
	if game_state.state.quest.size() != 0:
		var cur_id = QuestManage.get_current_quest_id()
		if !game_state.state.quest[cur_id]["success"]:
			QuestManage.check_quest_item(cur_id, herb_item_ref[herb_name])
		
		
func _on_Cancle_pressed():
	if has_node("HerbPickPopup"):
		get_node("HerbPickPopup/Panel").hide()
