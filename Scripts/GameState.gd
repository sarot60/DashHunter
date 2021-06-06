extends Node

signal gamestate_changed

var _fname := "gamestate.dat"
#var _fname := "user://play.data"

var state := {} setget _set_state
var saved_state := {} # backup if unable to save
var first_start := true

func _ready():
	print('game state')
	initiate()
	
#------------------------ set state ----------------------
func set_state( k, v, save_file := false ) -> bool:
	self.state[k] = v
	if save_file:
		return _save_gamestate()
	return true
func _set_state( v ):
	state = v
	emit_signal("gamestate_changed")
#---------------------------------------------------------

# Define initial game state
func initiate():
	state = _get_initial_gamestate()
	if Game.debug:
		state.active_checkpoint = [ \
			state.current_pos, state.current_lvl ]
		pass
	saved_state = state.duplicate(true)

func _get_initial_gamestate():
	if Game.debug:
			return debug_gamestate
	return { 
		"current_pos": [90, -20],
		
		"cur_hp": 70,
		"cur_sp": 80,
		"cur_stamina": 100,
		
		"max_hp": 100,
		"max_sp": 100,
		"max_stamina": 100,
		
		"cur_village": "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn",
		"level": 1,
		"exp": 0,
	}
# save game state to file
func save_gamestate() -> bool:
	return _save_gamestate()
func _save_gamestate() -> bool:
	print( "SAVING GAMESTATE:" )
	saved_state = state.duplicate( true )
#	return false
	var f := File.new()
	var err := f.open_encrypted_with_pass( \
			_fname, File.WRITE, OS.get_unique_id() )
	if err == OK:
		f.store_var( state )
		f.close()
		return true
	else:
		f.close()
		return false

# load game state from file
func load_gamestate() -> bool:
	var aux = _load_gamestate()
	if aux.empty():
		if Game.debug: print( "gamestate: unable to load gamestate file" )
		if not saved_state.empty():
			if Game.debug: print( "gamestate: using locally saved variable" )
			state = saved_state.duplicate( true )
		else:
			if Game.debug: print( "gamestate: using initial gamestate" )
			state = _get_initial_gamestate()
			saved_state = state.duplicate( true )
		return false
	state = aux
	saved_state = state.duplicate( true )
	first_start = false
	return true
func _load_gamestate() -> Dictionary:
	var f := File.new()
	if not f.file_exists( _fname ):
		return {}
	var err = f.open_encrypted_with_pass( \
			_fname, File.READ, OS.get_unique_id() )
	if err != OK:
		f.close()
		return {}
	var data = f.get_var()
	f.close()
	return data

func check_gamestate_file() -> bool:
	var tempstate = _load_gamestate()
	if tempstate.empty(): return false
	return true
	
var debug_gamestate = { \
	"datetime" : 0, \
#	"events" : [], \
	"events" : [ "first dialog with wolf", "bitten" ], \
#	"events" : [ "first dialog with wolf", "bitten" ,"black chrystal"], \
#	"events" : ["green chrystal"], \
#		"events" : ["green chrystal","white chrystal"], \
#		"events" : ["green chrystal","white chrystal","red chrystal"], \
	"destructibles" : [], \
	"dead_robots": [], \
	"active_checkpoint": [ "", "" ], \
	"switches" : [], \
	"visited_stages" : [], \
#	"current_lvl" : "", \
#	"current_lvl" : "res://zones/mountain/stage_05.tscn", \
	"current_lvl" : "res://zones/forest/stage_14.tscn", \
#	"current_lvl" : "res://zones/cave/stage_04.tscn", \
#		"current_pos" : "finish_position", \
#		"current_pos" : "cutscene_position", \
	"current_pos" : "", \
	"current_dir" : 1, \
	"current_player_status" : "start", \
	"can_double_jump" : true, \
	"can_wall_jump" : true, \
	"can_attack" : true, \
	"can_push" : false, \
	"green_chrystal" : false, \
	"white_chrystal" : false, \
	"red_chrystal" : false, \
	"attack_reach" : 0.7, \
	"energy" : 3, \
	"max_energy" : 3 }


""" --------------------------------------------------------------------
							debug for testing
-------------------------------------------------------------------- """

