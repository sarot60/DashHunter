extends Area2D

var damage = 0

func _ready():
	set_physics_process(false)
	

func _physics_process(delta):
	if $AnimatedSprite.frame >= 10:
		$CollisionShape2D.set_deferred("disabled", true)

func _on_StartUpAnimation_animation_finished(_anim_name):
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# call in Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [0.5, 20, 10, 0])
	$AnimatedSprite.play("default")
	$BombSound.play(0)
	$CollisionShape2D.set_deferred("disabled", false)
	set_physics_process(true)

func _on_AnimatedSprite_animation_finished():
	queue_free()
