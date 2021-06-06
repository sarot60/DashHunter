extends Panel

class_name QuestPanel

var quest_name
var quest_index

func initialize_quest(quest_index):
	self.quest_index = quest_index
	var quest = game_state.state.quest[quest_index]
	var quest_data = JsonData.quest_data[quest_index]
	
	
	quest_name = quest_data["quest_name"]
	$QuestName.text = quest_name
	$NPC.text = "NPC : " + quest_data["npc"]
