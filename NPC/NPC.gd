extends KinematicBody2D
#
#var player:Object = null
#
#export(String,
#"", 
#"Jack",
#"Bravo",
#"Brave",
#"Ethan",
#"Lucien",
#"Jacob",
#"Brooke"
#) var NPC_NAME
#
#var NPC_TYPE = {
#	"Jack": "GENERAL",
#	"Bravo": "TRANSPORT",
#	"Brave": "ALCHEMIST",
#	"Ethan": "MERCHANT",
#	"Lucien": "PROFESSOR",
#	"Jacob": "BLACKSMITH",
#	"Brooke": "MERCHANT"
#}
#
#var self_npc_name:String
#var self_npc_type:String
#
#func _ready():
#
#	if has_node("Emotion/CurrentQuest") and has_node("Emotion/SuccessQuest"):
#		$Emotion/CurrentQuest.hide()
#		$Emotion/SuccessQuest.hide()
#
#	set_process(false)
#
#	if NPC_NAME != "" and NPC_TYPE[NPC_NAME] != "":
#
#		self.self_npc_name = NPC_NAME
#		self.self_npc_type = NPC_TYPE[NPC_NAME]
#
#		if has_node("NameLabel"):
#			$NameLabel.text = self_npc_name
#		if has_node("TypeLabel"):
#			$TypeLabel.text = self_npc_type
#
#		if has_node("PlayerDetection"):
#			var _Con1 = get_node("PlayerDetection").connect("body_entered", self, "_on_PlayerDetection_body_entered")
#			var _Con2 = get_node("PlayerDetection").connect("body_exited", self, "_on_PlayerDetection_body_exited")
#
#	add_to_group("current_quest_is_accept")
#
#	add_to_group("accept_reward")
#
#	if has_node("Emotion/SuccessQuest"):
#		if game_state.state.current_quest_success:
#			$Emotion/SuccessQuest.show()
#
#	if has_node("Emotion/CurrentQuest"):
#		if !game_state.state.current_quest_accept:
#			$Emotion/CurrentQuest.show()
#
#func check_current_quest_is_accept(_b):
#	if has_node("Emotion/CurrentQuest"):
#		$Emotion/CurrentQuest.hide()
#
#func check_accept_reward(_b):
#	if has_node("Emotion/SuccessQuest"):
#		$Emotion/SuccessQuest.hide()
#
#func npc_working(t) -> void:
#	if Game.main == null: return
#
#	match t:
#		"GENERAL":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/GENERAL").show()
#				var _Con1 = get_node("SelectTalkButton/GENERAL/Talk").connect("pressed", self, "_on_Talk_pressed")
#		"TRANSPORT":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/TRANSPORT").show()
#				var _Con1 = get_node("SelectTalkButton/TRANSPORT/Travel").connect("pressed", self, "_on_Travel_pressed")
#				var _Con2 = get_node("SelectTalkButton/TRANSPORT/Talk").connect("pressed", self, "_on_Talk_pressed")
#		"ALCHEMIST":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/ALCHEMIST").show()
#				var _Con1 = get_node("SelectTalkButton/ALCHEMIST/Talk").connect("pressed", self, "_on_Talk_pressed")
#				var _Con2 = get_node("SelectTalkButton/ALCHEMIST/Shop").connect("pressed", self, "_on_Shop_pressed")
#		"MERCHANT":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/MERCHANT").show()
#				var _Con1 = get_node("SelectTalkButton/MERCHANT/Talk").connect("pressed", self, "_on_Talk_pressed")
#				var _Con2 = get_node("SelectTalkButton/MERCHANT/Shop").connect("pressed", self, "_on_Shop_pressed")
#		"PROFESSOR":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/PROFESSOR").show()
#				var _Con1 = get_node("SelectTalkButton/PROFESSOR/Talk").connect("pressed", self, "_on_Talk_pressed")
#				var _Con2 = get_node("SelectTalkButton/PROFESSOR/Learn").connect("pressed", self, "_on_Learn_pressed")
#		"BLACKSMITH":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/BLACKSMITH").show()
#				var _Con1 = get_node("SelectTalkButton/BLACKSMITH/Talk").connect("pressed", self, "_on_Talk_pressed")
#				var _Con2 = get_node("SelectTalkButton/BLACKSMITH/Shop").connect("pressed", self, "_on_Shop_pressed")
#				var _Con3 = get_node("SelectTalkButton/BLACKSMITH/Upgrade").connect("pressed", self, "_on_Upgrade_pressed")
#
#func npc_stop_working(t) -> void:
#	if Game.main == null: return
#
#	match t:
#		"GENERAL":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/GENERAL").hide()
#				get_node("SelectTalkButton/GENERAL/Talk").disconnect("pressed", self, "_on_Talk_pressed")
#		"TRANSPORT":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/TRANSPORT").hide()
#				get_node("SelectTalkButton/TRANSPORT/Travel").disconnect("pressed", self, "_on_Travel_pressed")
#				get_node("SelectTalkButton/TRANSPORT/Talk").disconnect("pressed", self, "_on_Talk_pressed")
#			Game.main.get_node("GUI/MapStation").hide()
#		"ALCHEMIST":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/ALCHEMIST").hide()
#				get_node("SelectTalkButton/ALCHEMIST/Talk").disconnect("pressed", self, "_on_Talk_pressed")
#				get_node("SelectTalkButton/ALCHEMIST/Shop").disconnect("pressed", self, "_on_Shop_pressed")
#		"MERCHANT":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/MERCHANT").hide()
#				get_node("SelectTalkButton/MERCHANT/Talk").disconnect("pressed", self, "_on_Talk_pressed")
#				get_node("SelectTalkButton/MERCHANT/Shop").disconnect("pressed", self, "_on_Shop_pressed")
#
#				get_node("SelectTalkButton/MerchantShop").hide()
#		"PROFESSOR":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/PROFESSOR").hide()
#				get_node("SelectTalkButton/PROFESSOR/Talk").disconnect("pressed", self, "_on_Talk_pressed")
#				get_node("SelectTalkButton/PROFESSOR/Learn").disconnect("pressed", self, "_on_Learn_pressed")
#		"BLACKSMITH":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/BLACKSMITH").hide()
#				get_node("SelectTalkButton/BLACKSMITH/Talk").disconnect("pressed", self, "_on_Talk_pressed")
#				get_node("SelectTalkButton/BLACKSMITH/Shop").disconnect("pressed", self, "_on_Shop_pressed")
#				get_node("SelectTalkButton/BLACKSMITH/Upgrade").disconnect("pressed", self, "_on_Upgrade_pressed")
#
#				get_node("SelectTalkButton/BlacksmithShop").hide()
#				get_node("SelectTalkButton/BlacksmithUpgrade").hide()
#
#
#func close_button_talk(t) -> void:
#	if Game.main == null: return
#
#	match t:
#		"GENERAL":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/GENERAL").hide()
#		"TRANSPORT":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/TRANSPORT").hide()
#		"ALCHEMIST":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/ALCHEMIST").hide()
#		"MERCHANT":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/MERCHANT").hide()
#		"PROFESSOR":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/PROFESSOR").hide()
#		"BLACKSMITH":
#			if has_node("SelectTalkButton"):
#				get_node("SelectTalkButton/BLACKSMITH").hide()
#
#
#func self_quest():
#	if Game.main == null: return
#	pass
#
## ---------------------------------- Signal --------------------------------------
#
## player entered
#func _on_PlayerDetection_body_entered(body):
#	if player != null: return
#	player = body
#	if has_node("Emotion/HintTalk"):
#		$Emotion/HintTalk.show()
#	set_process(true)
#
#	npc_working(self_npc_type)
#
## player exited
#func _on_PlayerDetection_body_exited(_body):
#	if Game.main == null: return
#
#	player = null
#	if has_node("Emotion/HintTalk"):
#		$Emotion/HintTalk.hide()
#	set_process(false)
#
#	npc_stop_working(self_npc_type)
#
#	Game.main.get_node("Dialogue").close_dialogue()
#
## for TRANSPORT or NPC for Transport
#func _on_Travel_pressed():
#	Game.main.get_node("GUI/MapStation").show()
#	if has_node("SelectTalkButton"):
#		get_node("SelectTalkButton/TRANSPORT").hide()
#
## for BLACKSMITH ALCHAMIST MERCHANT or NPC for sell item or buy item
#func _on_Shop_pressed():
#	if self_npc_type == "MERCHANT":
#		if has_node("SelectTalkButton"):
#			get_node("SelectTalkButton/MerchantShop").show()
#	elif self_npc_type == "BLACKSMITH":
#		if has_node("SelectTalkButton"):
#			get_node("SelectTalkButton/BlacksmithShop").show()
#			get_node("SelectTalkButton/BLACKSMITH").hide()
#
## for BLACKSMITH or NPC Upgrade equipment
#func _on_Upgrade_pressed():
#	if self_npc_type == "BLACKSMITH":
#		if has_node("SelectTalkButton"):
#			get_node("SelectTalkButton/BlacksmithUpgrade").show()
#
#			get_node("SelectTalkButton/BlacksmithUpgrade").initialize_item()
#
## for PROFESSOR or NPC Learn skill
#func _on_Learn_pressed():
#	print('learn')
#
## for all NPC
#func _on_Talk_pressed():
#	Game.main.get_node("Dialogue").initialize_dialogue(self)
#	close_button_talk(self_npc_type)
