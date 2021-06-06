extends CanvasLayer

func _ready():
	pass

func _on_Timer_timeout():
	if Game.main == null: return
	
	Game.main.LoadScreen( Game.main.MAINMENU_SCENE )


