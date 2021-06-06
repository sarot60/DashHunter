extends KinematicBody2D

# Emeny Movement
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

# Enemy Stats
var max_health = 100
onready var health = max_health setget set_health

# monster attack
export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

# Variable for check
var target
var hit_pos
var can_shoot = false
var is_death = false
var death_spent_time = 0
var first_detect = false

# State
enum {
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
	ATTACK,
}
var state = IDLE

# Preload
onready var blood1 = preload("res://Effects/BloodEffect1/BloodEffect1.tscn")

# Call child node
onready var anim_player = $AnimationPlayer

func _ready():
	#$HealthBar.value = health
	
	#$Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	#$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			play_anim("idle")
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
				var direction = (target.global_position - global_position).normalized()
				flip(direction)
				aim()
		
	velocity = move_and_slide(velocity)

func flip(direction):
	if direction.x > 0:
		# ขวา
		$Sprite.scale.x = 1
	else:
		# ซ้าย
		$Sprite.scale.x = -1
		
func set_health(value):
	health = value
	
func update_healthbar():
	#$HealthBar.value = health
	pass
	
func death():
	
#	create_effect_object.create_drop_coin([1,5])
#
#	create_effect_object.create_death_effect()
#
#	create_effect_object.create_blood_effect()
	
	is_death = true
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	state = DEATH
	
func _on_Hurtbox_area_entered(area):
	health -= 30

#	create_effect_object.create_floating_text(30)
	
#	create_effect_object.create_hit_effect2()

	update_healthbar()
	if health <= 0:
		death()
	
	if health > 0:
#		create_effect_object.create_hit_effect3()
		pass
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 200

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
#	for pos in [target.position]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player" or result.collider.name == "Player3" or result.collider.name == "Player2":
				#$Sprite.self_modulate.r = 1.0
				#rotation = (target.position - position).angle()
				if can_shoot:
					shoot(pos)
				if first_detect:
					play_anim("attack")
					first_detect = false
				break

func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	b.global_position = global_position + Vector2(-6, -6)
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
	play_anim("idle")
	
func _draw():
	#draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			#draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			#draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)
			pass

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	state = ATTACK
	
	first_detect = true

	
func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		#$Sprite.self_modulate.r = 0.2
		#state = IDLE
		
		first_detect = false
		play_anim("idle")
		can_shoot = false
		
		state = IDLE
		
		$ShootTimer.stop()


func _on_ShootTimer_timeout():
	play_anim("attack")
	#can_shoot = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		can_shoot = true
		
		
