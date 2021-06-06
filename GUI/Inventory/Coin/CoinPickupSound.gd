extends AudioStreamPlayer2D



func _on_CoinPickupSound_finished():
	queue_free()
