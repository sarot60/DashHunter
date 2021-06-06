extends Node

#var _fname := "gamestate.dat"
var _fname := "user://gamestate.dat"



var state := {} setget _set_state
var saved_state := {} # backup if unable to save
var first_start := true


func _ready():
	initiate()

func _set_state( v ):
	state = v
	
func initiate() -> void:
	state = _get_initial_gamestate()
	saved_state = state.duplicate(true)

func _get_initial_gamestate() -> Dictionary:
	return {
		"cur_hp": 50,
		"cur_sp": 50,
		#"cur_stamina": 100,
		
		"coin": 10000,
		
		# status 
		#"max_hp": 50,
		#"max_sp": 50,
		#"max_stamina": 100,
		#"damage": 30,
		#"defend": 30,
		#"critical_rate": 50, # percent
		#"critical_damage": 10, # percent
		#"speed": 200,
		
		"level": 19,
		"cur_exp": 0,
		# ต้องการ exp 6 เพื่อไป Lv2
		"req_exp": 6400,
		
		"quest": {
#			0: {
#				"accept": false,	
#				"success": false,
#				"send_mission": false
#			},
		},
		
#		"current_quest_accept": false,
#		"current_quest_success": false,
#		"quest_reward": false,
		
		"cur_village": "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn",
		
		"skill_slot": {
			0 : null,
			1 : null,
			2 : null
		},
		
		# max = 20 slot
		#  ---> slot_index: [item_name, item_quantity, item_tier]
		"player_inventory": {
			0: ["Short Wooden Sword", 1, 0], #  ---> slot_index: [item_name, item_quantity, item_tier]
			1: ["Lv1 Mp Potion", 10, 0],
			2: ["Fennis sword", 1, 10]
#			3: ["Lv4 Health Potion", 20, 0],
#			4: ["Bone", 1, 0],
#			5: ["Lv4 Mp Potion", 20, 0],
#			6: ["Empty Grinding Cup", 1, 7],
#			8: ["Lv1 Health Potion", 90, 0],
#			9: ["Lv3 Empty Potion", 21, 0],
		},
		"player_equipment": {
			
		},
		"player_use_item_slot": {
			0: ["Lv1 Health Potion", 30, 0],
			1: ["Lv4 Health Potion", 43, 0],
#			2: ["Iron Ore", 92, 0],
#			3: ["Lv3 Mp Potion", 55, 0],
#			4: ["Lv3 Health Potion", 1, 0]
		},
		
	}
	
func save_gamestate() -> bool:
	return write_data()
func write_data() -> bool:
	print( "SAVING GAMESTATE:" )
	var f = File.new()
	saved_state = state.duplicate( true )
	f.open( _fname , File.WRITE )
	f.store_var(saved_state)
	f.close()
	return true
	
func _get_music_state():
	pass
	
func load_gamestate() -> bool:
	var aux = load_data()
	if aux.empty():
		#if Game.debug: print( "gamestate: unable to load gamestate file" )
		if not saved_state.empty():
			#if Game.debug: print( "gamestate: using locally saved variable" )
			state = saved_state.duplicate( true )
		else:
			#if Game.debug: print( "gamestate: using initial gamestate" )
			state = _get_initial_gamestate()
			saved_state = state.duplicate( true )
		return false
	state = aux
	saved_state = state.duplicate( true )
	first_start = false
	return true
func load_data() -> Dictionary:
	var f := File.new()
	if not f.file_exists( _fname ):
		return {}
	if f.file_exists(_fname):
		f.open( _fname , File.READ )
		var data = f.get_var()
		f.close()
		return data
	return {}
	
func check_gamestate_file() -> bool:
	var tmpstate:Dictionary = load_data()
	if tmpstate.empty(): return false
	return true


# ----------- settinh 
var music_state_file := "user://musicstate.dat"
var music_state = {"music_setting":1}

func check_setting_state_file() -> bool:
	var tmpstate:Dictionary = load_setting_data()
	if tmpstate.empty(): return false
	return true

func load_setting_data() -> Dictionary:
	var f := File.new()
	if not f.file_exists( music_state_file ):
		return {}
	if f.file_exists(music_state_file):
		f.open( music_state_file , File.READ )
		var data = f.get_var()
		f.close()
		return data
	return {}
	
func save_setting_data() -> bool:
	var f = File.new()
	var tmp_music = music_state.duplicate( true )
	f.open( music_state_file , File.WRITE )
	print(tmp_music)
	f.store_var(tmp_music)
	f.close()
	print('save setting success')
	return true
