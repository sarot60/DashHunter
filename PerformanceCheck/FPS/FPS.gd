extends Control


func _ready():
	set_process(true)

func _process(_delta):
	$FPS.text = str(Performance.get_monitor(Performance.TIME_FPS)) + "FPS"
