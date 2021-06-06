extends AudioStreamPlayer2D


func _on_InsectDeathSFX_finished():
	queue_free()
