extends CanvasLayer

var MAINMENU_SCENE = "res://Screens/StartMenu/StartMenu.tscn"

func _ready():
	togle_text()

func _on_Back_pressed():
	Game.main.LoadScreen(MAINMENU_SCENE)

func togle_text():
	if Game.main != null:
		var music_config_state = game_state.load_setting_data()
		if music_config_state.music_setting == 1:
			$music_status_bg/Status.text = "OPEN"
		else:
			$music_status_bg/Status.text = "MUTE"
		
func _on_MusicOpen_pressed():
	game_state.music_state.music_setting = 1
	game_state.save_setting_data()
	Game.main.music_config(1)
	togle_text()

func _on_MusicMute_pressed():
	game_state.music_state.music_setting = 0
	game_state.save_setting_data()
	Game.main.music_config(0)
	togle_text()
