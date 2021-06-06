extends Control

class_name QuestGUI

onready var quest_detail = $QuestDetail
onready var quest_panel_object = $QuestPanelObject
onready var quest_list = $CurrentQuest/ScrollContainer/GridContainer

func _ready():
	#hide()
	
	initialize_quest_gui()
		
	initialize_quest_popup()

func initialize_quest_gui():
	var quest = game_state.state.quest
	var quest_data = JsonData.quest_data
	if quest_list.get_children().size() > 0:
		for i in quest_list.get_children():
			i.queue_free()
	if quest.size() > 0:
		for i in range(quest.size()):
			if quest[i]["accept"]:
				var quest_panel = quest_panel_object.duplicate()
				quest_panel.name = "Quest" + str(i)
				quest_panel.connect("gui_input", self, "quest_panel_gui_input", [quest_panel])
				quest_panel.quest_index = i
				quest_panel.initialize_quest(i)
				
				quest_list.add_child(quest_panel)
	
func initialize_quest_popup():
	quest_detail.hide()
	#print(game_state.state.quest)
	#print(JsonData.quest_data)
	
func update_quest_detail(quest_panel):
	var quest_index = quest_panel.quest_index
	var quest = game_state.state.quest[quest_index]
	var quest_data = JsonData.quest_data[quest_index]
	quest_detail.show()
	quest_detail.get_node("QuestName").text = quest_panel.quest_name
	#print(quest_panel.quest_index)
	var str_info = ""
	
	str_info += "=================="
	str_info += "\nNPC : " + quest_data["npc"] + "\n"
	
	str_info += "\n=================="
	str_info += "\nDescription :  " + quest_data["description"] + "\n"
	
	str_info += "\n=================="
	str_info += "\nPosition :  " + quest_data["position"] + "\n"
	
	str_info += "\n=================="
	str_info += "\nItem Require : " + "\n"
	for i in range(quest["item_require"].size()):
		str_info += str(quest["item_require"][i]["item_id"]) 
		if quest["item_require"][i]["received"]:
			str_info += "[color=#2ecc71] 1/1[/color]\n"
		else:
			str_info += "[color=#e74c3c] 0/1[/color]\n"
	
	str_info += "\n=================="
	str_info += "\nCoin Reward : " + str(quest_data["coin_reward"]) +" Coin\n"
	
	str_info += "\n=================="
	str_info += "\nExp Reward : " + str(quest_data["exp_reward"]) + " EXP\n"
	
	str_info += "\n=================="
	str_info += "\nItem Reward : " + "\n"
	for i in range(quest_data["item_reward"].size()):
		str_info += str(quest_data["item_reward"][i]) + "\n"
	
	str_info += "\n=================="
	if quest["accept"]:
		str_info += "\nQuest Accept : [color=#2ecc71]Yes[/color]\n"
	else:
		str_info += "\nQuest Accept : [color=#e74c3c]No[/color]\n"
	
	str_info += "\n=================="
	if quest["success"]:
		str_info += "\nQuest Success : [color=#2ecc71]Yes[/color]\n"
	else:
		str_info += "\nQuest Success : [color=#e74c3c]No[/color]\n"
	
	str_info += "\n=================="
	if quest["send_mission"]:
		str_info += "\nQuest Send Mission : [color=#2ecc71]Yes[/color]\n"
	else:
		str_info += "\nQuest Send Mission : [color=#e74c3c]No[/color]\n"
			
#	str_info += "\n\n\n"
#	str_info += str(quest) + "\n\n"
#	str_info += str(quest_data) + "\n"
	$QuestDetail/RichTextLabel.set_bbcode(str_info) 

func quest_panel_gui_input(event: InputEvent, quest_panel):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			update_quest_detail(quest_panel)

func _on_CloseQuestPopup_pressed():
	get_tree().call_group("update_inv", "update_inv_status", false)
	hide()
