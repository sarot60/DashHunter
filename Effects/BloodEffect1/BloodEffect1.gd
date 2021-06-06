extends CPUParticles2D


func _ready():
	yield(get_tree().create_timer(3),"timeout")
	queue_free()

	pass


func _on_Timer_timeout():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
