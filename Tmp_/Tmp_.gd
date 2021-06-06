extends Area2D



func _on_GrassSwaying_body_entered(body):
	$Grown.visible = false
	$Growing.frame = 0
	$Growing.play("grow")
	$Growing.visible = true


func _on_Growing_animation_finished():
	$Grown.visible = true
	$Growing.visible = false
