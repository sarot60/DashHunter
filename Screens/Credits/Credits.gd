extends CanvasLayer


var MAINMENU_SCENE = "res://Screens/StartMenu/StartMenu.tscn"

func _on_Back_pressed():
	Game.main.LoadScreen(MAINMENU_SCENE)
