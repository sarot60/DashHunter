extends CanvasLayer

var self_npc_name:String
var self_npc_type:String

var dialog_json = {
#	"0":"Hello",
#	"1":"I am NPC 01",
#	"2":"Help me please",
#	"3":"Help xxxxczxczxc"
}

var page = 0

var quest_talk_dialog = false

onready var dialog_text = $DialoguePanel/RichTextLabel

func _ready():
	
	set_process_input(false)
	
	$DialoguePanel.hide()
	var _tmp1 = $DialoguePanel/CloseButton.connect("pressed", self, "_on_CloseButton_pressed")
	var _tmp2 = $DialoguePanel/AcceptButton.connect("pressed", self, "_on_AcceptButton_pressed")
	var _tmp3 = $DialoguePanel/SuccessButton.connect("pressed", self, "_on_SuccessButton_pressed")

func initialize_dialogue(npc_name:String, npc_type:String):
	self_npc_name = npc_name
	self_npc_type = npc_type
	
	page = 0
	
	$DialoguePanel.show()
	
	$DialoguePanel/NpcName.text = self_npc_name
	
	var current_quest_id = QuestManage.get_current_quest_id()
	var player_quest = game_state.state.quest
	if !player_quest[current_quest_id]["accept"]:
		$DialoguePanel/AcceptButton.show()
	else:
		$DialoguePanel/AcceptButton.hide()
		
	if player_quest[current_quest_id]["success"]:
		if player_quest[current_quest_id]["send_mission"]: return
		$DialoguePanel/SuccessButton.show()
	else:
		$DialoguePanel/SuccessButton.hide()
	
	dialog_json = JsonData.quest_data[current_quest_id]["dialogue"]
	
	start_dialog()


func _input(event):
	if quest_talk_dialog:
		if event.is_action_pressed("ui_select"):
			if dialog_text.get_visible_characters() > dialog_text.get_total_character_count():
				if page < dialog_json.size()-1:
					page += 1
					dialog_text.set_bbcode(dialog_json[page])
					dialog_text.set_visible_characters(0)
			else:
				dialog_text.set_visible_characters(dialog_text.get_total_character_count())

func start_dialog():
	quest_talk_dialog = true
	
	set_process_input(true)
	dialog_text.set_bbcode(dialog_json[page])
	dialog_text.set_visible_characters(0)
	dialog_text.set_process_input(true)
	
	$DialogTimer.start()
	
func _on_CloseButton_pressed():
	$DialoguePanel.hide()

func _on_AcceptButton_pressed():
	# Call to NPCPack.gd
	get_tree().call_group("update_quest_icon", "update_quest_icon", self)
	
	# Call to TextAlert.gd
	get_tree().call_group("add_data_to_play", "add_data_to_play", "Quest Accept")
	$DialoguePanel.hide()
	
	var current_quest_id = QuestManage.get_current_quest_id()
	game_state.state.quest[current_quest_id]["accept"] = true
	
func _on_SuccessButton_pressed():
	# Call to NPCPack.gd
	get_tree().call_group("update_quest_icon", "update_quest_icon", self)
	$DialoguePanel.hide()
	var current_quest_id = QuestManage.get_current_quest_id()
	
	AddExperience.add_exp(JsonData.quest_data[current_quest_id]["exp_reward"])
	AddExperience.add_coin(JsonData.quest_data[current_quest_id]["coin_reward"])

	game_state.state.quest[current_quest_id]["send_mission"] = true
	
	
func _on_DialogTimer_timeout():
	dialog_text.set_visible_characters(dialog_text.get_visible_characters()+1)
	
	if dialog_text.get_visible_characters() > dialog_text.get_total_character_count():
		if page == dialog_json.size()-1:
			#if gamestate.state.quest.accepted_quest == 0:
			#	$dialog_panel/button_group/accept_quest_button.show()
			
			#if gamestate.state.quest.success_current_quest == 1:
			#	$dialog_panel/button_group/success_quest.show()
			
			$DialoguePanel/CloseButton.show()
			
			$DialogTimer.stop()
