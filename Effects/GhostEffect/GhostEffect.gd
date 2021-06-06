extends Sprite



func _ready():
	$AlphaTween.interpolate_property(self, "modulate", Color(0, 1, 1, 1), Color(1, 1, 0, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT )
	$AlphaTween.start()
	
#	$AlphaTween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT )

func _on_AlphaTween_tween_completed(_object, _key):
	queue_free()
