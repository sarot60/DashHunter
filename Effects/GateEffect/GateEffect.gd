extends Node2D

func _ready():
	hide()

func start():
	show()
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	hide()
