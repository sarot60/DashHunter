extends Node

	
func use_hp_potion(number_of_hp:int):
	var cur_hp = PlayerStats.cur_hp
	var max_hp = PlayerStats.max_hp
	var hp_balance = number_of_hp + cur_hp
	if hp_balance > max_hp:
		PlayerStats.cur_hp = max_hp 
	else:
		PlayerStats.cur_hp = hp_balance
	game_state.state.cur_hp = PlayerStats.cur_hp
	# Call to HelthBar.gd
	get_tree().call_group("update_bar", "update_all_bar")
	# Call to Player.gd
	get_tree().call_group("player_create_effect", "player_create_heal_effect", self)

func use_sp_potion(number_of_sp:int):
	var cur_sp = PlayerStats.cur_sp
	var max_sp = PlayerStats.max_sp
	var sp_balance = number_of_sp + cur_sp
	if sp_balance > max_sp:
		PlayerStats.cur_sp = max_sp 
	else:
		PlayerStats.cur_sp = sp_balance
	game_state.state.cur_sp = PlayerStats.cur_sp
	# Call to HelthBar.gd
	get_tree().call_group("update_bar", "update_all_bar")
	# Call to Player.gd
	get_tree().call_group("player_create_effect", "player_create_heal_effect", self)
