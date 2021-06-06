extends CanvasLayer

var self_npc_name
var self_npc_type

var is_current_quest = false

onready var npc_button = $NPC_Button
onready var npc_popup = $NPC_Popup
onready var npc_dialogue = $NPC_Dialogue

func _ready():
	pass
	
func initialize_npc_data(npc_name, npc_type):
	self_npc_name = npc_name
	self_npc_type = npc_type
	
func initialize_general_button():
	var _tmp1 = $NPC_Button/GENERAL/QuestButton.connect("pressed", self, "_on_QuestButton_pressed")
	
	is_current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	
	if !is_current_quest:
		$NPC_Button/GENERAL/QuestButton.disabled = true
		$NPC_Button/GENERAL/QuestButton.modulate = Color(1, 1, 1, 0.5)
	else:
		$NPC_Button/GENERAL/QuestButton.disabled = false
		$NPC_Button/GENERAL/QuestButton.modulate = Color(1, 1, 1, 1)
		
func close_general_button():
	$NPC_Button/GENERAL/QuestButton.disconnect("pressed", self, "_on_QuestButton_pressed")
	hide_button()
	hide_popup()
	hide_dialog()

func initialize_merchant_button():
	var _tmp1 = $NPC_Button/MERCHANT/QuestButton.connect("pressed", self, "_on_QuestButton_pressed")
	var _tmp2 = $NPC_Button/MERCHANT/ShopButton.connect("pressed", self, "_on_ShopButton_pressed")
	var _tmp3 = $NPC_Button/MERCHANT/SellItem.connect("pressed", self, "_on_SellItemButton_pressed")
	
	is_current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	
	if !is_current_quest:
		$NPC_Button/MERCHANT/QuestButton.disabled = true
		$NPC_Button/MERCHANT/QuestButton.modulate = Color(1, 1, 1, 0.5)
	else:
		$NPC_Button/MERCHANT/QuestButton.disabled = false
		$NPC_Button/MERCHANT/QuestButton.modulate = Color(1, 1, 1, 1)
func close_merchant_button():
	$NPC_Button/MERCHANT/QuestButton.disconnect("pressed", self, "_on_QuestButton_pressed")
	$NPC_Button/MERCHANT/ShopButton.disconnect("pressed", self, "_on_ShopButton_pressed")
	$NPC_Button/MERCHANT/SellItem.disconnect("pressed", self, "_on_SellItemButton_pressed")
	hide_button()
	hide_popup()
	hide_dialog()

func initialize_alchemist_button():
	var _tmp1 = $NPC_Button/ALCHEMIST/QuestButton.connect("pressed", self, "_on_QuestButton_pressed")
	var _tmp2 = $NPC_Button/ALCHEMIST/ShopButton.connect("pressed", self, "_on_ShopButton_pressed")
	
	is_current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	
	if !is_current_quest:
		$NPC_Button/ALCHEMIST/QuestButton.disabled = true
		$NPC_Button/ALCHEMIST/QuestButton.modulate = Color(1, 1, 1, 0.5)
	else:
		$NPC_Button/ALCHEMIST/QuestButton.disabled = false
		$NPC_Button/ALCHEMIST/QuestButton.modulate = Color(1, 1, 1, 1)
func close_alchemist_button():
	$NPC_Button/ALCHEMIST/QuestButton.disconnect("pressed", self, "_on_QuestButton_pressed")
	$NPC_Button/ALCHEMIST/ShopButton.disconnect("pressed", self, "_on_ShopButton_pressed")
	hide_button()
	hide_popup()
	hide_dialog()

func initialize_professor_button():
	var _tmp1 = $NPC_Button/PROFESSOR/QuestButton.connect("pressed", self, "_on_QuestButton_pressed")
	
	is_current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	
	if !is_current_quest:
		$NPC_Button/PROFESSOR/QuestButton.disabled = true
		$NPC_Button/PROFESSOR/QuestButton.modulate = Color(1, 1, 1, 0.5)
	else:
		$NPC_Button/PROFESSOR/QuestButton.disabled = false
		$NPC_Button/PROFESSOR/QuestButton.modulate = Color(1, 1, 1, 1)
func close_professor_button():
	$NPC_Button/PROFESSOR/QuestButton.disconnect("pressed", self, "_on_QuestButton_pressed")
	hide_button()
	hide_popup()
	hide_dialog()
	
func initialize_blacksmith_button():
	var _tmp1 = $NPC_Button/BLACKSMITH/QuestButton.connect("pressed", self, "_on_QuestButton_pressed")
	var _tmp2 = $NPC_Button/BLACKSMITH/ShopButton.connect("pressed", self, "_on_ShopButton_pressed")
	var _tmp3 = $NPC_Button/BLACKSMITH/UpgradeButton.connect("pressed", self, "_on_UpgradeButton_pressed")
	
	is_current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	
	if !is_current_quest:
		$NPC_Button/BLACKSMITH/QuestButton.disabled = true
		$NPC_Button/BLACKSMITH/QuestButton.modulate = Color(1, 1, 1, 0.5)
	else:
		$NPC_Button/BLACKSMITH/QuestButton.disabled = false
		$NPC_Button/BLACKSMITH/QuestButton.modulate = Color(1, 1, 1, 1)
func close_blacksmith_button():
	$NPC_Button/BLACKSMITH/QuestButton.disconnect("pressed", self, "_on_QuestButton_pressed")
	$NPC_Button/BLACKSMITH/ShopButton.disconnect("pressed", self, "_on_ShopButton_pressed")
	$NPC_Button/BLACKSMITH/UpgradeButton.disconnect("pressed", self, "_on_UpgradeButton_pressed")
	hide_button()
	hide_popup()
	hide_dialog()

func initialize_transport_button():
	var _tmp1 = $NPC_Button/TRANSPORT/QuestButton.connect("pressed", self, "_on_QuestButton_pressed")
	var _tmp2 = $NPC_Button/TRANSPORT/WarpButton.connect("pressed", self, "_on_WarpButton_pressed")
	
	is_current_quest = QuestManage.find_current_quest(self_npc_name, self_npc_type)
	
	if !is_current_quest:
		$NPC_Button/TRANSPORT/QuestButton.disabled = true
		$NPC_Button/TRANSPORT/QuestButton.modulate = Color(1, 1, 1, 0.5)
	else:
		$NPC_Button/TRANSPORT/QuestButton.disabled = false
		$NPC_Button/TRANSPORT/QuestButton.modulate = Color(1, 1, 1, 1)
func close_transport_button():
	$NPC_Button/TRANSPORT/QuestButton.disconnect("pressed", self, "_on_QuestButton_pressed")
	$NPC_Button/TRANSPORT/WarpButton.disconnect("pressed", self, "_on_WarpButton_pressed")
	hide_button()
	hide_popup()
	hide_dialog()
	
func hide_button():
	match self_npc_type:
		"GENERAL":
			$NPC_Button/GENERAL.hide()
		"BLACKSMITH":
			$NPC_Button/BLACKSMITH.hide()
		"TRANSPORT":
			$NPC_Button/TRANSPORT.hide()
		"ALCHEMIST":
			$NPC_Button/ALCHEMIST.hide()
		"MERCHANT":
			$NPC_Button/MERCHANT.hide()
		"PROFESSOR":
			$NPC_Button/PROFESSOR.hide()
			
func hide_popup():
	match self_npc_type:
		"GENERAL":
			pass
		"BLACKSMITH":
			npc_popup.get_node("BlacksmithShop").hide()
			npc_popup.get_node("BlacksmithUpgrade").hide()
		"TRANSPORT":
			npc_popup.get_node("MapStation").hide()
		"ALCHEMIST":
			npc_popup.get_node("AlchemistShop").hide()
		"MERCHANT":
			npc_popup.get_node("MerchantShop").hide()
			npc_popup.get_node("SellItem").hide()
		"PROFESSOR":
			pass

func hide_dialog():
	match self_npc_type:
		"GENERAL":
			npc_dialogue.get_node("DialoguePanel").hide()
		"BLACKSMITH":
			npc_dialogue.get_node("DialoguePanel").hide()
		"TRANSPORT":
			npc_dialogue.get_node("DialoguePanel").hide()
		"ALCHEMIST":
			npc_dialogue.get_node("DialoguePanel").hide()
		"MERCHANT":
			npc_dialogue.get_node("DialoguePanel").hide()
		"PROFESSOR":
			npc_dialogue.get_node("DialoguePanel").hide()

# ----------------------- Signals -------------------------------

# for general
func _on_QuestButton_pressed():
	if !is_current_quest: return
	
	hide_button()
	
	npc_dialogue.initialize_dialogue(self_npc_name, self_npc_type)

# for transport
func _on_WarpButton_pressed():
	hide_button()
	npc_popup.get_node("MapStation").show()

func _on_ShopButton_pressed():
	hide_button()
	match self_npc_type:
		"MERCHANT":
			npc_popup.get_node("MerchantShop").show()
			npc_popup.get_node("MerchantShop").update_shop_ui()
		"BLACKSMITH":
			npc_popup.get_node("BlacksmithShop").show()
			npc_popup.get_node("BlacksmithShop").update_shop_ui()
		"ALCHEMIST":
			npc_popup.get_node("AlchemistShop").show()
			npc_popup.get_node("AlchemistShop").update_shop_ui()

func _on_UpgradeButton_pressed():
	hide_button()
	npc_popup.get_node("BlacksmithUpgrade").show()
	npc_popup.get_node("BlacksmithUpgrade").clear_popup()
	npc_popup.get_node("BlacksmithUpgrade").initialize_item()

func _on_SellItemButton_pressed():
	hide_button()
	npc_popup.get_node("SellItem").show()
	npc_popup.get_node("SellItem").clear_popup()
	npc_popup.get_node("SellItem").initialize_inventory()
	
