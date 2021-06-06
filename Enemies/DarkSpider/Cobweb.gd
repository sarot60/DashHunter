extends Area2D

var speed = 150
var velocity = Vector2()

var damage = 0

func _ready():
	pass
	
func start(pos, dir):
	position = pos
	#rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	
func _on_Cobweb_body_entered(body):
	queue_free()
