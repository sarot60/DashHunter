extends CanvasLayer

var self_npc:Object = null

var page = 0

var first_talk_dialog = false
var quest_talk_dialog = false

#tmp
var dia1 = "HELLO MY NAME IS JACK"
var dia2 = "PLEASE HELP ME"
var dia3 = "I NEED HERBS TO HEAL MY BURNS"
var dia4 = "CAN YOU GET AN ALOE VERA FOR ME?"
var dia5 = "GO TO GREENVETA DUNGEON 1 FOR FIND THE ALOE VERA PLANT"

var cur_dia = 1

func _ready():
	$DialoguePanel.hide()
	$DialoguePanel/AcceptQuest.hide()
	$DialoguePanel/SuccessQuest.hide()

func initialize_dialogue(npc:Object):
	if npc == null:return
	
	$DialoguePanel.show()
	self_npc = npc
#	print(npc.self_npc_name)
	
	$DialoguePanel/NpcName.text = self_npc.self_npc_name
	
	if self_npc.self_npc_type != "GENERAL":
		$DialoguePanel/Next.hide()
	else:
		$DialoguePanel/Next.show()
	
	cur_dia = 1
	$DialoguePanel/RichTextLabel.text = "HELLO MY NAME IS JACK"
	
func close_dialogue():
	$DialoguePanel.hide()
	self_npc = null

func first_start_dialog():
	pass


func _on_Next_pressed():
	if cur_dia == 1:
		$DialoguePanel/RichTextLabel.text = dia2
		cur_dia = 2
	elif cur_dia == 2:
		$DialoguePanel/RichTextLabel.text = dia3
		cur_dia = 3
	elif cur_dia == 3:
		$DialoguePanel/RichTextLabel.text = dia4
		cur_dia = 4
	elif cur_dia == 4:
		$DialoguePanel/RichTextLabel.text = dia5
		cur_dia = 5
		$DialoguePanel/Next.hide()
		if !game_state.state.current_quest_accept:
			$DialoguePanel/AcceptQuest.show()
		if game_state.state.current_quest_success == true and game_state.state.quest_reward == false:
			$DialoguePanel/SuccessQuest.show()
			game_state.state.quest_reward = true
			get_tree().call_group("accept_reward", "check_accept_reward", true)
			
func hide_all():
	$DialoguePanel.hide()
	$DialoguePanel/AcceptQuest.hide()
	$DialoguePanel/SuccessQuest.hide()
		
func _on_Close_pressed():
	pass # Replace with function body.


func _on_AcceptQuest_pressed():
	game_state.state.current_quest_accept = true
	hide_all()
	get_tree().call_group("current_quest_is_accept", "check_current_quest_is_accept", true)


func _on_SuccessQuest_pressed():
	game_state.state.current_quest_success = true
	
	game_state.state.coin += 50
	game_state.state.cur_exp += 50
	
	get_tree().call_group("update_coin", "update_coin" , self)
	hide_all()
