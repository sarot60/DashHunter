extends Node2D

var damage = 0

func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "play":
		queue_free()


func _on_ShadowAnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("play")
	$BombSound.play(0)
