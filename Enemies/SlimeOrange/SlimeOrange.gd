extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200

var max_health = 100
onready var health = max_health setget set_health

var is_death = false
var death_spent_time = 0

onready var blood1 = preload("res://Effects/BloodEffect1/BloodEffect1.tscn")

# monster attack
export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

var target
var hit_pos
var can_shoot = true

enum {
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
	ATTACK,
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = IDLE

onready var create_effect_object = $CreateEffectObject

func _ready():
	$HealthBar.value = health
	
	#$Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		WANDER:
			pass
			
		CHASE:
			pass
			
		DEATH:
			if is_death:
				death_spent_time += delta
				if death_spent_time >= 0:
					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		ATTACK:
			update()
			if target:
				aim()
		
	velocity = move_and_slide(velocity)

	
func set_health(value):
	health = value
	
func update_healthbar():
	$HealthBar.value = health
	
func death():
	
	create_effect_object.create_drop_coin([1,5])
	
	create_effect_object.create_death_effect()
	
	create_effect_object.create_blood_effect()
	
	is_death = true
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	state = DEATH
	
func _on_Hurtbox_area_entered(area):
	health -= 30

	create_effect_object.create_floating_text(30)
	
#	create_effect_object.create_hit_effect()
	create_effect_object.create_hit_effect2()

	update_healthbar()
	if health <= 0:
		death()
	
	if health > 0:
		create_effect_object.create_hit_effect3()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 200

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var _target_extents = target.get_node('CollisionShape2D').shape.extents
	for pos in [target.position]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player" or result.collider.name == "Player3" or result.collider.name == "Player2":
				#$Sprite.self_modulate.r = 1.0
				#rotation = (target.position - position).angle()
				if can_shoot:
					shoot(pos)
				break

func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
	
func _draw():
	#draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			#draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			#draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)
			pass

func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	state = ATTACK


func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		#$Sprite.self_modulate.r = 0.2
		#state = IDLE

func _on_ShootTimer_timeout():
	can_shoot = true
