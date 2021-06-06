extends Node

func _ready():
#	for i in range(1,31):
#		print("level ",i," = ",nextLevel(i),"xp")
	#add_exp(624)
	
#	print(nextLevel(15))
#	print(7/10)
	
	pass

# pow ยกกำลัง
func nextLevel(level):
	return round((4 * (pow(level,3))) / 5)
	
	
func add_exp(exp_count:float = 0.0):
	var cur_lv = game_state.state.level
	var cur_exp = game_state.state.cur_exp
	var req_exp = game_state.state.req_exp
	
	cur_exp += exp_count
	
	if cur_exp == req_exp:
		cur_exp = 0
		cur_lv += 1
		req_exp = nextLevel(cur_lv + 1)
		
		game_state.state.level = cur_lv
		game_state.state.cur_exp = cur_exp
		game_state.state.req_exp = req_exp
		
		get_tree().call_group("update_bar", "update_level_progress" , self)
		
		# Call to PlayerStats.gd
		get_tree().call_group("calculate_stats", "calculate_stats", self)
		return
	
	if cur_exp > req_exp:
		
		var t = true
		while t == true:
			var exp_balance = cur_exp - req_exp
			cur_lv += 1
			req_exp = nextLevel(cur_lv + 1)
			
			cur_exp = exp_balance
			game_state.state.level = cur_lv
			game_state.state.cur_exp = cur_exp
			game_state.state.req_exp = req_exp
			
			if req_exp > exp_balance:
				t = false
				break
		get_tree().call_group("update_bar", "update_level_progress" , self)
		
		# Call to PlayerStats.gd
		get_tree().call_group("calculate_stats", "calculate_stats", self)
		return
		
	if cur_exp < req_exp:
		game_state.state.cur_exp = cur_exp
		
		get_tree().call_group("update_bar", "update_level_progress" , self)
		
		# Call to PlayerStats.gd
		get_tree().call_group("calculate_stats", "calculate_stats", self)
		return
		

func add_coin(coin_count:float = 0.0):
	if game_state.state == {}: return
	
	game_state.state.coin += coin_count
	get_tree().call_group("update_coin", "update_coin" , self)
	
	
func add_item(item_id:String = ""):
	pass


#level 1 = 1xp
#level 2 = 6xp
#level 3 = 22xp
#level 4 = 51xp
#level 5 = 100xp
#level 6 = 173xp
#level 7 = 274xp
#level 8 = 410xp
#level 9 = 583xp
#level 10 = 800xp
#level 11 = 1065xp
#level 12 = 1382xp
#level 13 = 1758xp
#level 14 = 2195xp
#level 15 = 2700xp
#level 16 = 3277xp
#level 17 = 3930xp
#level 18 = 4666xp
#level 19 = 5487xp
#level 20 = 6400xp
#level 21 = 7409xp
#level 22 = 8518xp
#level 23 = 9734xp
#level 24 = 11059xp
#level 25 = 12500xp
#level 26 = 14061xp
#level 27 = 15746xp
#level 28 = 17562xp
#level 29 = 19511xp
#level 30 = 21600xp
