extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	get_parent().set_physics_process(true)
	player = body
	


func _on_PlayerDetectionZone_body_exited(_body):
	player = null
	
