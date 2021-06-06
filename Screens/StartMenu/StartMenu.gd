extends CanvasLayer

var SETTINGS_SCENE = "res://Screens/Settings/Settings.tscn"
var CREDITS_SCENE = "res://Screens/Credits/Credits.tscn"

func _ready():
	# ถ้ามีไฟล์ หรือเคยเซฟไว้
	#if GameState.check_gamestate_file():
	if game_state.check_gamestate_file():
		print('is loaded game')
		#var _state = GameState.load_gamestate()
		var _state = game_state.load_gamestate()
		
	# ถ้าไม่มีคือต้องเริ่มเกมใหม่
	#elif GameState.first_start:
	elif game_state.first_start:
		print('is first start')
		
	if Game.main != null:
		Game.main.music_fsm(0)
		
func _input(event):
	if event.is_action_pressed("btn_quit"):
		#quit_game()
		get_tree().quit()
	pass


func selectedMenu(itemNoSelect:int):
	
	if Game.main == null: return
	
	match itemNoSelect:
		0:
			# start new game
			
			#GameState.initiate()
			#GameState.first_start = false
			game_state.initiate()
			game_state.first_start = false
			
			#print(game_state.state)

			#var _new = GameState.save_gamestate()
			var _new = game_state.save_gamestate()
			
			Game.main.curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
			Game.main.LoadGameState()
		1:
			#if GameState.first_start == false:
			if game_state.first_start == false:
				Game.main.curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
				Game.main.LoadGameState()

				print('continue game')
			
		2:
			Game.main.LoadScreen(SETTINGS_SCENE)
		3:
			Game.main.LoadScreen(CREDITS_SCENE)
		4:
			get_tree().quit()

func AlertStartNewGame():
	pass 

func AlertQuitGame():
	pass

func StartNewGame():
	pass
	
# ------------------------------- Signal ------------------------------


func _on_NewGame_pressed():
	selectedMenu(0)

func _on_ContinueGame_pressed():
	selectedMenu(1)
	
func _on_Settings_pressed():
	selectedMenu(2)

func _on_Credits_pressed():
	selectedMenu(3)
	
func _on_QuitGame_pressed():
	selectedMenu(4)


