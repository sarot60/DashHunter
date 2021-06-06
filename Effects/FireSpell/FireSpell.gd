extends Area2D

var damage = 0

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if $AnimatedSprite.frame == 2:
		$AnimatedSprite2.play("default")
		$CollisionShape2D.set_deferred("disabled", false)
		# duration ระยะเวลา
		# frequency ความถี่
		# amplitude ความกว้าง
		# priority ลำดับ ตัวเลขมากทำก่อน
		# call in Player3 or Other Player
		$BombSound.play(0)
		get_tree().call_group("camera_shake", "camera_shake", [1, 12, 8, 0])
	if $AnimatedSprite2.frame == 2:
		$AnimatedSprite3.play("default")
	if $AnimatedSprite3.frame == 2:
		$AnimatedSprite4.play("default")
	if $AnimatedSprite4.frame == 2:
		$AnimatedSprite5.play("default")
		$CollisionShape2D.set_deferred("disabled", true)

func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimatedSprite.play("default")
	set_physics_process(true)


func _on_AnimatedSprite5_animation_finished():
	queue_free()
