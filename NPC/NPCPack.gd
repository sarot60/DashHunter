extends Node2D

export(String,
"", 
"GENERAL",
"BLACKSMITH",
"TRANSPORT",
"ALCHEMIST",
"MERCHANT",
"PROFESSOR"
) var self_npc_type

var self_npc_name

onready var npc_gui:CanvasLayer = $NPC_GUI
onready var general_button:GridContainer = $NPC_GUI/NPC_Button/GENERAL
onready var transport_button:GridContainer = $NPC_GUI/NPC_Button/TRANSPORT
onready var merchant_button:GridContainer = $NPC_GUI/NPC_Button/MERCHANT
onready var alchemist_button:GridContainer = $NPC_GUI/NPC_Button/ALCHEMIST
onready var professor_button:GridContainer = $NPC_GUI/NPC_Button/PROFESSOR
onready var blacksmith_button:GridContainer = $NPC_GUI/NPC_Button/BLACKSMITH

#var current_quest_img
#var waiting_quest_img
#var success_quest_img

func _ready():
	
	# call from QuestManage.gd
	add_to_group("update_quest_icon")

	self_npc_name = get_parent().name
	
	if has_node("PlayerDetection"):
		var _Tmp1 = get_node("PlayerDetection").connect("body_entered", self, "_on_PlayerDetection_body_entered")
		var _Tmp2 = get_node("PlayerDetection").connect("body_exited", self, "_on_PlayerDetection_body_exited")
		
	if self_npc_name != null:
		$NameLabel.text = self_npc_name
	if self_npc_type != null:
		$TypeLabel.text = self_npc_type
		
	for i in $Emotion.get_children():
		i.hide()
		
	update_quest_icon(null)
		
	npc_gui.initialize_npc_data(self_npc_name, self_npc_type)
	
# call from QuestManage.gd
func update_quest_icon(_shadow_param):
	var status
	for i in $Emotion.get_children():
		i.hide()
		
	var current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	if current_quest:
		status = "current_quest"
		var quest = game_state.state.quest[QuestManage.get_current_quest_id()]
		if quest["accept"]:
			status = "waiting_for_quest"
		if quest["success"]:
			status = "success"
		if quest["send_mission"]:
			status = ""
			$OffScreen.hide()
	else:
		$OffScreen.hide()
		return
		
	match status:
		"current_quest":
			$Emotion/CurrentQuest.show()
			$OffScreen/QuestOffScreen/Sprite/Icon.texture = load("res://Assets/Other/current-quest.png")
			$OffScreen.show()
		"waiting_for_quest":
			$Emotion/WaitingQuest.show()
			$OffScreen/QuestOffScreen/Sprite/Icon.texture = load("res://Assets/Other/waiting-quest.png")
			$OffScreen.show()
		"success":
			$Emotion/SuccessQuest.show()
			$OffScreen/QuestOffScreen/Sprite/Icon.texture = load("res://Assets/Other/success-quest.png")
			$OffScreen.show()
		_:
			for i in $Emotion.get_children():
				i.hide()
			$OffScreen.hide()
		
func open_talk_button():
	if self_npc_type == null: return
	if self_npc_type == "": return
	
	match self_npc_type:
		"GENERAL":
			general_button.show()
			npc_gui.initialize_general_button()
		"BLACKSMITH":
			blacksmith_button.show()
			npc_gui.initialize_blacksmith_button()
		"TRANSPORT":
			transport_button.show()
			npc_gui.initialize_transport_button()
		"ALCHEMIST":
			alchemist_button.show()
			npc_gui.initialize_alchemist_button()
		"MERCHANT":
			merchant_button.show()
			npc_gui.initialize_merchant_button()
		"PROFESSOR":
			professor_button.show()
			npc_gui.initialize_professor_button()
			
func hide_talk_button():
	if self_npc_type == null: return
	if self_npc_type == "": return
	
	match self_npc_type:
		"GENERAL":
			general_button.hide()
			npc_gui.close_general_button()
		"BLACKSMITH":
			blacksmith_button.hide()
			npc_gui.close_blacksmith_button()
		"TRANSPORT":
			transport_button.hide()
			npc_gui.close_transport_button()
		"ALCHEMIST":
			alchemist_button.hide()
			npc_gui.close_alchemist_button()
		"MERCHANT":
			merchant_button.hide()
			npc_gui.close_merchant_button()
		"PROFESSOR":
			professor_button.hide()
			npc_gui.close_professor_button()

func _on_PlayerDetection_body_entered(_body):
	$hello_speak.play()
	open_talk_button()
	
func _on_PlayerDetection_body_exited(_body):
	hide_talk_button()
