extends CPUParticles2D

#func _process(_delta):
#	if !emitting:
#		queue_free()

var emit_time = 0
func _process(delta):
	emit_time += delta
	if emit_time >= 0.2:
		emitting = false

func _on_Timer_timeout():
	queue_free()
