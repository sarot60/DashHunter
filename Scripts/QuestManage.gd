extends Node

var npc_name
var npc_type

func find_current_quest(_name, _type) -> bool:
	if _name == null: return false
	if _name == "": return false
	if _type == null: return false
	if _type == "": return false
	
	npc_name = _name
	npc_type = _type
	
	# initialize first quest when new game
	if game_state.state.quest.size() == 0:
		add_next_quest(0)
		
	var quest_id = get_current_quest_id()
	# ทำเมื่อส่งเควสก่อนหน้าไปแล้ว
	if game_state.state.quest[get_current_quest_id()]["send_mission"]:
		var all_quest_count = JsonData.quest_data.size() - 1
		if !quest_id + 1 > all_quest_count:
			add_next_quest(quest_id + 1)
			
	var player_quest = game_state.state.quest
	var json_quest_data = JsonData.quest_data
	
	if json_quest_data[player_quest.size()-1]["npc"] == npc_name:
		return true
	
	return false
	
func add_next_quest(next_index:int) -> void:
	var item_req_data = JsonData.quest_data[next_index]["item_require"]
	var item_req_dict = {}
	for i in range(item_req_data.size()):
		item_req_dict[i] = {
			"item_id": item_req_data[i]["item_id"],
			"received": false
		}
	var quest_status = {
		"accept": false,
		"success": false,
		"send_mission": false,
		"item_require": item_req_dict
	}
	game_state.state.quest[next_index] = quest_status
	
func get_current_quest_id() -> int:
	if game_state.state.quest.size() == 0: return -1
	var cur_id = game_state.state.quest.size() - 1
	return cur_id

# เชคไอเทมที่ส่งเข้ามาว่าเป็ตเควสไหม
func check_quest_item(quest_id, item_id):
	if game_state.state.quest.size() == 0: return
	if game_state.state.quest[quest_id]["item_require"].size() < 1: return
	
	var accept = game_state.state.quest[quest_id]["accept"]
	var success = game_state.state.quest[quest_id]["success"]
	
	if !accept: return
	if success: return
	
	var item_req = game_state.state.quest[quest_id]["item_require"]
	
	for i in item_req:
		if !item_req[i]["received"]:
			if item_id == item_req[i]["item_id"]:
				game_state.state.quest[quest_id]["item_require"][i]["received"] = true
				check_quest_success(quest_id)
				
# check ว่าเสร็จหมดยัง
func check_quest_success(quest_id):
	var check_is_true = 0
	var item_req = game_state.state.quest[quest_id]["item_require"]
	for i in item_req:
		if !item_req[i]["received"]:
			check_is_true += 1
			
	if check_is_true == 0:
		game_state.state.quest[quest_id]["success"] = true
		
	# Call to NPCPack.gd
	get_tree().call_group("update_quest_icon", "update_quest_icon", self)

func check_quest_talk(_quest_id, _npc_name):
	if game_state.state.quest.size() == 0: return
	pass
