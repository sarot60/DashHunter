extends Node

var max_hp
var max_sp
var max_stamina = 100
var damage
var defend
var critical_rate
var critical_damage
var speed = 100
var cur_hp
var cur_sp
var cur_stamina = 100

var equipment_slot_ref = {
	0: "Weapon",
	1: "Shield",
	2: "Armor",
	3: "Shoes",
	4: "Helmet",
	5: "Accessories",
	6: "Accessories",
}

var price_to_next_upgrade = {
	0: 0,
	1: 50,
	2: 100,
	3: 150,
	4: 200,
	5: 250,
	6: 300,
	7: 350,
	8: 400,
	9: 450,
	10: 500
}

var item_tier_damage_bonus = {
	0: {"bonus":0, "price_to_next": 2},
	1: {"bonus":2, "price_to_next": 2},
	2: {"bonus":4, "price_to_next": 2},
	3: {"bonus":6, "price_to_next": 2},
	4: {"bonus":8, "price_to_next": 2},
	5: {"bonus":10, "price_to_next": 2},
	6: {"bonus":12, "price_to_next": 2},
	7: {"bonus":14, "price_to_next": 2},
	8: {"bonus":16, "price_to_next": 2},
	9: {"bonus":18, "price_to_next": 2},
	10: {"bonus":20, "price_to_next": 0},
}
var item_tier_defend_bonus = {
	0: {"bonus":0, "price_to_next": 2},
	1: {"bonus":2, "price_to_next": 2},
	2: {"bonus":4, "price_to_next": 2},
	3: {"bonus":6, "price_to_next": 2},
	4: {"bonus":8, "price_to_next": 2},
	5: {"bonus":10, "price_to_next": 2},
	6: {"bonus":12, "price_to_next": 2},
	7: {"bonus":14, "price_to_next": 2},
	8: {"bonus":16, "price_to_next": 2},
	9: {"bonus":18, "price_to_next": 2},
	10: {"bonus":20, "price_to_next": 0},
}
var item_tier_hp_bonus = {
	0: {"bonus":0, "price_to_next": 2},
	1: {"bonus":10, "price_to_next": 2},
	2: {"bonus":20, "price_to_next": 2},
	3: {"bonus":30, "price_to_next": 2},
	4: {"bonus":40, "price_to_next": 2},
	5: {"bonus":50, "price_to_next": 2},
	6: {"bonus":60, "price_to_next": 2},
	7: {"bonus":70, "price_to_next": 2},
	8: {"bonus":80, "price_to_next": 2},
	9: {"bonus":90, "price_to_next": 2},
	10: {"bonus":100, "price_to_next": 0},
}
var item_tier_sp_bonus = {
	0: {"bonus":0, "price_to_next": 2},
	1: {"bonus":10, "price_to_next": 2},
	2: {"bonus":20, "price_to_next": 2},
	3: {"bonus":30, "price_to_next": 2},
	4: {"bonus":40, "price_to_next": 2},
	5: {"bonus":50, "price_to_next": 2},
	6: {"bonus":60, "price_to_next": 2},
	7: {"bonus":70, "price_to_next": 2},
	8: {"bonus":80, "price_to_next": 2},
	9: {"bonus":90, "price_to_next": 2},
	10: {"bonus":100, "price_to_next": 0},
}
var item_tier_critical_damage_bonus = {
	0: {"bonus":0, "price_to_next": 2},
	1: {"bonus":2, "price_to_next": 2},
	2: {"bonus":4, "price_to_next": 2},
	3: {"bonus":6, "price_to_next": 2},
	4: {"bonus":8, "price_to_next": 2},
	5: {"bonus":10, "price_to_next": 2},
	6: {"bonus":12, "price_to_next": 2},
	7: {"bonus":14, "price_to_next": 2},
	8: {"bonus":16, "price_to_next": 2},
	9: {"bonus":18, "price_to_next": 2},
	10: {"bonus":20, "price_to_next": 0},
}
var item_tier_critical_rate_bonus = {
	0: {"bonus":0, "price_to_next": 2},
	1: {"bonus":2, "price_to_next": 2},
	2: {"bonus":4, "price_to_next": 2},
	3: {"bonus":6, "price_to_next": 2},
	4: {"bonus":8, "price_to_next": 2},
	5: {"bonus":10, "price_to_next": 2},
	6: {"bonus":12, "price_to_next": 2},
	7: {"bonus":14, "price_to_next": 2},
	8: {"bonus":16, "price_to_next": 2},
	9: {"bonus":18, "price_to_next": 2},
	10: {"bonus":20, "price_to_next": 0},
}
#	2: {
#		0: {"bonus":0, "price_to_next": 2},
#		1: {"bonus":4, "price_to_next": 2},
#		2: {"bonus":8, "price_to_next": 2},
#		3: {"bonus":12, "price_to_next": 2},
#		4: {"bonus":16, "price_to_next": 2},
#		5: {"bonus":20, "price_to_next": 2},
#		6: {"bonus":24, "price_to_next": 2},
#		7: {"bonus":28, "price_to_next": 2},
#		8: {"bonus":32, "price_to_next": 2},
#		9: {"bonus":36, "price_to_next": 2},
#		10: {"bonus":40, "price_to_next": 0},
#	},
#	3: {
#		0: {"bonus":0, "price_to_next": 2},
#		1: {"bonus":6, "price_to_next": 2},
#		2: {"bonus":12, "price_to_next": 2},
#		3: {"bonus":18, "price_to_next": 2},
#		4: {"bonus":24, "price_to_next": 2},
#		5: {"bonus":30, "price_to_next": 2},
#		6: {"bonus":36, "price_to_next": 2},
#		7: {"bonus":42, "price_to_next": 2},
#		8: {"bonus":48, "price_to_next": 2},
#		9: {"bonus":54, "price_to_next": 2},
#		10: {"bonus":60, "price_to_next": 2}, 
#	},


#var start_stats = {
#	1: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 50, "max_sp": 50},
#	2: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 60, "max_sp": 60},
#	3: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 70, "max_sp": 70},
#	4: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 80, "max_sp": 80},
#	5: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 90, "max_sp": 90},
#	6: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 100, "max_sp": 100},
#	7: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 110, "max_sp": 110},
#	8: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 120, "max_sp": 120},
#	9: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 130, "max_sp": 130},
#	10: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 140, "max_sp": 140},
#	11: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 150, "max_sp": 150},
#	12: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 160, "max_sp": 160},
#	13: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 170, "max_sp": 170},
#	14: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 180, "max_sp": 180},
#	15: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 190, "max_sp": 190},
#	16: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 200, "max_sp": 200},
#	17: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 240, "max_sp": 240},
#	18: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 280, "max_sp": 280},
#	19: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 300, "max_sp": 300},
#	20: {"dmg": 30, "def": 30, "crit_dmg": 2, "crit_rate": 90, "max_hp": 400, "max_sp": 400},
#}

var start_stats = {
	1: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 50, "max_sp": 50},
	2: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 60, "max_sp": 60},
	3: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 70, "max_sp": 70},
	4: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 80, "max_sp": 80},
	5: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 90, "max_sp": 90},
	6: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 100, "max_sp": 100},
	7: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 110, "max_sp": 110},
	8: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 120, "max_sp": 120},
	9: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 130, "max_sp": 130},
	10: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 140, "max_sp": 140},
	11: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 150, "max_sp": 150},
	12: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 160, "max_sp": 160},
	13: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 170, "max_sp": 170},
	14: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 180, "max_sp": 180},
	15: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 190, "max_sp": 190},
	16: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 200, "max_sp": 200},
	17: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 240, "max_sp": 240},
	18: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 280, "max_sp": 280},
	19: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 300, "max_sp": 300},
	20: {"dmg": 30, "def": 30, "crit_dmg": 10, "crit_rate": 30, "max_hp": 400, "max_sp": 400},
}


func _ready():
	
	# Call from BlacksmithUpgrade.gd
	add_to_group("calculate_stats")
	
	calculate_stats(null)

func initialize_player_stats():
	max_hp = start_stats[game_state.state.level]["max_hp"]
	max_sp = start_stats[game_state.state.level]["max_sp"]
	damage = start_stats[game_state.state.level]["dmg"]
	defend = start_stats[game_state.state.level]["def"]
	critical_rate = start_stats[game_state.state.level]["crit_rate"]
	critical_damage = start_stats[game_state.state.level]["crit_dmg"]
	#speed = game_state.state.speed
	
	cur_hp = game_state.state.cur_hp
	cur_sp = game_state.state.cur_sp
	

# Group calculate_stats / Call from BlacksmithUpgrade.gd
func calculate_stats(_param):
	initialize_player_stats()
	var equipment_slots = game_state.state.player_equipment
	for i in equipment_slot_ref:
		if equipment_slots.has(i):
			var item_detail = JsonData.item_data[equipment_slots[i][0]]
			if item_detail.has("HP"):
				max_hp += item_detail["HP"]
				
				var item_tier = equipment_slots[i][2]
				max_hp += item_tier_hp_bonus[item_tier]["bonus"]
				
			if item_detail.has("SP"):
				max_sp += item_detail["SP"]
				
				var item_tier = equipment_slots[i][2]
				max_sp += item_tier_sp_bonus[item_tier]["bonus"]
				
			if item_detail.has("Defend"):
				defend += item_detail["Defend"]
				
				#var item_lv = item_detail["ItemLevel"]
				var item_tier = equipment_slots[i][2]
				defend += item_tier_defend_bonus[item_tier]["bonus"]
				
			if item_detail.has("Damage"):
				damage += item_detail["Damage"]
				
				#var item_lv = item_detail["ItemLevel"]
				var item_tier = equipment_slots[i][2]
				damage += item_tier_damage_bonus[item_tier]["bonus"]
				
			if item_detail.has("CriticalDamage"):
				critical_damage += item_detail["CriticalDamage"]
				
				#var item_lv = item_detail["ItemLevel"]
				var item_tier = equipment_slots[i][2]
				critical_damage += item_tier_critical_damage_bonus[item_tier]["bonus"]
				
			if item_detail.has("CriticalRate"):
				critical_rate += item_detail["CriticalRate"]
				
				#var item_lv = item_detail["ItemLevel"]
				var item_tier = equipment_slots[i][2]
				critical_rate += item_tier_critical_rate_bonus[item_tier]["bonus"]
				
	# call to Inventory.gd
	get_tree().call_group("update_player_stats", "initialize_stats")
	
	# call to HelthBar.gd
	get_tree().call_group("update_bar", "initialize_health_bar")

func take_damage(enemy_dmg):
	if enemy_dmg <= 0:return
	
	# คำนวน damge ที่โจมตีกับ monster
	var calculate_dmg = float(enemy_dmg * (100.0/(100.0 + defend)))
	
	cur_hp -= calculate_dmg
	
	game_state.state.cur_hp = cur_hp
	game_state.state.cur_sp = cur_sp
	
	return calculate_dmg
	
func save_to_game_state():
	
	pass
