extends Area2D

var speed = 100
var velocity = Vector2()

var stop = false

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)
	
func _physics_process(delta):
	position += velocity * delta
	
func _on_SlimeOrangeFireBall_body_entered(_body):
	queue_free()
