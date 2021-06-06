extends Node2D
#extends Node

var GAMELOGO_SCENE = "res://GameLogo/GameLogo.tscn"
var MAINMENU_SCENE = "res://Screens/StartMenu/StartMenu.tscn"

var MAIN_SCENE = "res://Maps/MainVillage/MainVillage.tscn"

var music_state = 0

# ----------- map dungeon in game -----------------
#var GREEN_VETA_VILLAGE = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
#var GREEN_VETA_DUNGEON_1 = "res://Maps/GreenVeta/GreenVetaDungeon1/GreenVetaDungeon1.tscn"
#var GREEN_VETA_DUNGEON_2 = "res://Maps/GreenVeta/GreenVetaDungeon2/GreenVetaDungeon2.tscn"
#var GREEN_VETA_DUNGEON_3 = "res://Maps/GreenVeta/GreenVetaDungeon3/GreenVetaDungeon3.tscn"
#var GREEN_VETA_DUNGEON_4 = "res://Maps/GreenVeta/GreenVetaDungeon4/GreenVetaDungeon4.tscn"
#var GREEN_VETA_DUNGEON_5 = "res://Maps/GreenVeta/GreenVetaDungeon5/GreenVetaDungeon5.tscn"

func _ready():
	Game.main = self
	
	if game_state.check_setting_state_file() == true:
		print('have setting file')
		var music_config_state = game_state.load_setting_data()
		#print(music_config_state.music_setting)
		if music_config_state.music_setting == 1:
			music_config(1)
		else:
			music_config(0)
	else:
		game_state.save_setting_data()
		print('dont have setting file')
		
	LoadScreen( GAMELOGO_SCENE ) 

func music_config(s):
	if s == 1:
		# open music
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	else:
		# mute music
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		

var loadState = 0
var curScreen

func LoadScreen(scrn := ""):
	
	if not scrn.empty():
		loadState = 0
		curScreen = scrn
	
	match loadState:
		0:
			print( "LOADING SCREEN: ", curScreen )
			get_tree().paused = true
			
			if curScreen != "res://Screens/StartMenu/StartMenu.tscn" \
				and curScreen != "res://Screens/Settings/Settings.tscn" \
				and curScreen != "res://Screens/Credits/Credits.tscn": \
					$FadeLayer/FadeBackground.show()
	
			$FadeLayer/AnimationPlayer.play("Fade1")
			loadState = 1
			$ScreenTimer.set_wait_time(0.2)
			$ScreenTimer.start()
		1:
			var children = $Game.get_children()
			if not children.empty():
				children[0].queue_free()
			loadState = 2
			$ScreenTimer.set_wait_time( 0.05 )
			$ScreenTimer.start()
		2:
			var newLevel = load( curScreen ).instance()
			$Game.add_child( newLevel )
			loadState = 3
			$ScreenTimer.set_wait_time( 0.3 )
			$ScreenTimer.start()
		3:
			$FadeLayer/FadeBackground.hide()
			$FadeLayer/AnimationPlayer.play("Fade2")
			loadState = 4
			$ScreenTimer.set_wait_time( 0.2 )
			$ScreenTimer.start()
		4: 
			$PauseMenu/Pause.visible = false
			get_tree().paused = false
			loadState = 0

var curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
func LoadGameState():
	match loadState:
		0:
			#print( "LOADING STAGE: ", GREEN_VETA_VILLAGE )
			get_tree().paused = true
			$FadeLayer/AnimationPlayer.play("Fade1")
			loadState = 1
			$LoadGameStateTimer.set_wait_time( 0.2 )
			$LoadGameStateTimer.start()
		1:
			var children = $Game.get_children()
			if not children.empty():
				children[0].queue_free()
			loadState = 2
			$LoadGameStateTimer.set_wait_time( 0.05 )
			$LoadGameStateTimer.start()
		2:
			var newLevel = load(curMap).instance()
			$Game.add_child( newLevel )
			get_tree().paused = false
			#$hud_layer/hud/game_map.call_deferred( "_update_map" )
			
			initialize_GUI()
			initialize_HUD()
			
			PlayerInventory.initialize_PlayerInventory()
			PlayerStats.calculate_stats(null)
			# call to Inventory.gd
			get_tree().call_group("game_start", "game_start", self)
			
			$HUD/MiniMap.set_mini_map(curMap)
			
			game_state.state.cur_stamina = 100
			
			loadState = 3
			$LoadGameStateTimer.set_wait_time( 0.3 )
			$LoadGameStateTimer.start()
		3:
			$FadeLayer/AnimationPlayer.play("Fade2")
			loadState = 4
			$LoadGameStateTimer.set_wait_time( 0.2 )
			$LoadGameStateTimer.start()
		4:
			loadState = 0
			if curMap == "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn":
				music_fsm(1)
			else:
				music_fsm(2)

func initialize_GUI():
	$GUI.initialize_GUI()
	pass

func initialize_HUD():
	$HUD/HealthBar.initialize_health_bar()
	pass
	
const main_menu_music = preload("res://Assets/Music/awesomeness.wav")
const green_veta_dun_music = preload("res://Assets/Music/zapsplat/African_fun_long.wav")
const green_veta_music = preload("res://Assets/Music/zapsplat/cheeky_monkey_fun_app_playful_cheeky.wav")
func music_fsm(s):

	match s:
		0:
			$Music.stream = main_menu_music
			$Music.play(1)
			#$Music.volume_db = -10
			$Music.volume_db = -80
			music_state = 0
		1:
			$Music.stream = green_veta_music
			$Music.play(1)
			#$Music.volume_db = -10
			$Music.volume_db = -80
			music_state = 1
		2:
			$Music.stream = green_veta_dun_music
			$Music.play(1)
			#$Music.volume_db = -10
			$Music.volume_db = -80
			music_state = 2
			
# ---------------------------- Signal -------------------------

func _on_ScreenTimer_timeout():
	LoadScreen()


func _on_LoadGameStateTimer_timeout():
	LoadGameState()


func _on_Music_finished():
	music_fsm(music_state)
