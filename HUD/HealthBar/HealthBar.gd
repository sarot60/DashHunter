extends Control


var cur_stamina = 0

onready var lv_progress = $LevelFrame

onready var hp_hud = $Health
onready var sp_hud = $SP
onready var stamina_hud = $Stamina


func _ready():
	update_coin(0)

	add_to_group("update_bar")
	add_to_group("update_coin")
	
	#if GameState.state == {}:
	#	return
	if game_state.state == {}:
		return
		
	initialize_health_bar()
	
func initialize_health_bar():
	set_bar_value(PlayerStats.cur_hp, "hp")
	set_bar_value(PlayerStats.cur_sp, "sp")
	set_bar_value(cur_stamina, "stamina")
	
	lv_progress.get_node("Level").text = str(game_state.state.level)
	lv_progress.get_node("TextureProgress").max_value = game_state.state.req_exp
	lv_progress.get_node("TextureProgress").value = game_state.state.cur_exp
	
	hp_hud.get_node("BarFrame/TextureProgress").max_value = PlayerStats.max_hp
	hp_hud.get_node("BarFrame/TextureProgress").value = PlayerStats.cur_hp
	hp_hud.get_node("BarFrame/HpNumber").text = str(round(PlayerStats.cur_hp)) + "/" + str(PlayerStats.max_hp)
	
	sp_hud.get_node("BarFrame/TextureProgress").max_value = PlayerStats.max_sp
	sp_hud.get_node("BarFrame/TextureProgress").value = PlayerStats.cur_sp
	sp_hud.get_node("BarFrame/MpNumber").text = str(round(PlayerStats.cur_sp)) + "/" + str(PlayerStats.max_sp)
	
	stamina_hud.get_node("BarFrame/TextureProgress").max_value = PlayerStats.max_stamina
	stamina_hud.get_node("BarFrame/TextureProgress").value = PlayerStats.cur_stamina
	stamina_hud.get_node("BarFrame/StaminaNumber").text = str(PlayerStats.cur_stamina) + "/" + str(PlayerStats.max_stamina)
	

func _process(_delta):
	
	if cur_stamina < 100:
		cur_stamina += 0.5
		#cur_stamina = round(cur_stamina)

		if cur_stamina > 100:
			cur_stamina = 100

		#GameState.state.cur_stamina = cur_stamina
		#set_bar_value(GameState.state.cur_stamina, "stamina")
		PlayerStats.cur_stamina = cur_stamina
		set_bar_value(PlayerStats.cur_stamina, "stamina")
	pass

func update_coin(_d):
	$Coin/Label.text = str(game_state.state.coin)
	

func update_level_progress(_param):
	lv_progress.get_node("Level").text = str(game_state.state.level)
	lv_progress.get_node("TextureProgress").max_value = game_state.state.req_exp
	lv_progress.get_node("TextureProgress").value = game_state.state.cur_exp


func update_all_bar():
	#set_bar_value(GameState.state.cur_hp,"hp")
	#set_bar_value(GameState.state.cur_sp,"sp")
	#set_bar_value(GameState.state.cur_stamina,"stamina")
	set_bar_value(PlayerStats.cur_hp,"hp")
	set_bar_value(PlayerStats.cur_sp,"sp")
	set_bar_value(PlayerStats.cur_stamina,"stamina")
	update_coin(0)

func update_stamina_bar(_sta):
	#set_bar_value(GameState.state.cur_stamina, "stamina")
	#cur_stamina = GameState.state.cur_stamina
	set_bar_value(PlayerStats.cur_stamina, "stamina")
	cur_stamina = PlayerStats.cur_stamina

func set_bar_value(value, type:String):
	match type:
		"hp":
			$Health/BarFrame/TextureProgress.value = value
			hp_hud.get_node("BarFrame/HpNumber").text = str(round(value)) + "/" + str(PlayerStats.max_hp)
		"sp":
			$SP/BarFrame/TextureProgress.value = value
			sp_hud.get_node("BarFrame/MpNumber").text = str(round(value)) + "/" + str(PlayerStats.max_sp)
		"stamina":
			$Stamina/BarFrame/TextureProgress.value = value
			stamina_hud.get_node("BarFrame/StaminaNumber").text = str(round(value)) + "/" + str(PlayerStats.max_stamina)
	pass
