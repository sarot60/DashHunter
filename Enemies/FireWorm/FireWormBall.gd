extends Area2D

var speed = 150
var velocity = Vector2()

var damage = 0

func _ready():
	pass
	
func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta

func _on_FireWormBall_body_entered(body):
	$AnimationPlayer.play("explosion")
	
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explosion":
		queue_free()


func _on_FireWormBall_area_entered(area):
	$AnimationPlayer.play("explosion")
	
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
