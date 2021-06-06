extends CanvasLayer

var MAINMENU_SCN = "res://Screens/StartMenu/StartMenu.tscn"

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		get_node("Pause").visible = new_pause_state

func resume_pause():
	get_tree().paused = false
	get_node("Pause").visible = false
	
# -------------------------------- Signal --------------------------------------
	
func _on_TouchScreenButton_pressed():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	get_node("Pause").visible = new_pause_state


func _on_Resume_pressed():
	get_tree().paused = false
	$Pause.visible = false


func _on_PauseButton_pressed():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	get_node("Pause").visible = new_pause_state


func _on_Save_pressed():
	if Game.main == null: return
	if Game.player == null: return
	
	#GameState.state.current_pos = [Game.player.global_position.x, Game.player.global_position.y]
	#GameState.save_gamestate()
	game_state.state.current_pos = [Game.player.global_position.x, Game.player.global_position.y]
	var _tmp = game_state.save_gamestate()
	
	print('save')
	
	get_tree().paused = false
	$Pause.visible = false


func _on_Exit_pressed():
	if Game.main == null: return
	Game.main.LoadScreen( MAINMENU_SCN )
	
	
	
	#setting.save_settingstate()
