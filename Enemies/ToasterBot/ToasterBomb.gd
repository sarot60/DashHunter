extends Node2D

func _ready():
	set_physics_process(false)
	
func start():
	set_physics_process(true)
	show()
	$AnimatedSprite.play()
	$AnimatedSprite2.play()
	$AnimatedSprite3.play()
	$AnimatedSprite4.play()
	$AnimatedSprite5.play()
	$AnimatedSprite6.play()
	$AnimatedSprite7.play()
	$AnimatedSprite8.play()
	$AnimatedSprite9.play()
	$AnimatedSprite10.play()
	
func _physics_process(delta):
	if $AnimatedSprite.frame == 4:
		# duration ระยะเวลา
		# frequency ความถี่
		# amplitude ความกว้าง
		# priority ลำดับ ตัวเลขมากทำก่อน
		# call in Player3 or Other Player
		get_tree().call_group("camera_shake", "camera_shake", [0.2, 15, 10, 0])
		get_parent().create_effect_object.create_attack_line_effect()

func _on_AnimatedSprite_animation_finished():
	get_parent().death()
