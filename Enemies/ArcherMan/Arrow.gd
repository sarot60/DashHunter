extends Area2D

var speed = 300
var velocity = Vector2()

var stop = false

var hit_player = false

func _ready():
	if hit_player:
		$QueueFreeTimer.set_wait_time(5)
		$QueueFreeTimer.start()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)
	
func _physics_process(delta):
	position += velocity * delta


func _on_Arrow_body_entered(body):
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
#	if body.name == "Player2" and !stop:
#		queue_free()
		
	if !stop:
		if has_node("ArrowTrail"):
			get_node("ArrowTrail").queue_free()
		
	stop = true
	
	$QueueFreeTimer.set_wait_time(10)
	$QueueFreeTimer.start()
	

func _on_Arrow_area_entered(area):
	if area.name == "Hurtbox" and !stop:
		set_physics_process(false)
		$CollisionShape2D.set_deferred("disabled", true)
		stop = true
		if Game.player != null:
			var arrow_obj = self.duplicate()
			if arrow_obj.has_node("ArrowTrail"):
				arrow_obj.get_node("ArrowTrail").queue_free()
			arrow_obj.global_position = Vector2(0, -12)
			arrow_obj.get_node("CollisionShape2D").set_deferred("disabled", true)
			arrow_obj.set_physics_process(false)
			arrow_obj.hit_player = true
			arrow_obj.get_node("Sprite").flip_h = true
			Game.player.get_node("Sprite").call_deferred("add_child", arrow_obj)
			queue_free()
			pass

func _on_QueueFreeTimer_timeout():
	queue_free()
