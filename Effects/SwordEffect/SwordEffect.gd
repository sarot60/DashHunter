extends Node2D

func _ready():
	#yield(get_tree().create_timer(0.3),"timeout")
	#queue_free()
	$AlphaTween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_SINE, Tween.EASE_OUT )
	$AlphaTween.start()



func _on_AlphaTween_tween_completed(object, key):
	queue_free()
