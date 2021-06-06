extends KinematicBody2D

var rng = RandomNumberGenerator.new()

# Emeny Movement
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

# monster attack
export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)
export (PackedScene) var YellowThunder

# Variable for check
var target
var hit_pos
var can_shoot = true
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

onready var create_effect_object = $CreateEffectObject

# enemy stats
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var enemy_stats = {}

func _ready():
	#$HealthBar.value = health
	
	enemy_stats = EnimyStats.get_enemy_stats("FireMageGolem")
	
	if enemy_stats.size() == 0: 
		#playerDetectionZone.get_node("CollisionShape2D").disabled = true
		if has_node("Hitbox"):
			$Hitbox/CollisionShape2D.disabled = true
		return
		
	self.health = enemy_stats["max_hp"]
	max_speed = enemy_stats["speed"]
	atk = enemy_stats["atk"]
	def = enemy_stats["def"]
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
	
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
	
	create_effect_object.create_death_effect()
	
	create_effect_object.create_attack_line_effect()
	
	create_effect_object.create_blood_effect()
	
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# call in Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [0.2, 15, 10, 0])
	
	create_effect_object.create_drop_coin([1,5])
	create_effect_object.create_item_drop(["Yellow Gem", "Yellow Gem", "Rock", "Rock", "Rock"])
	
	AddExperience.add_exp(20)
	
	is_death = true
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	state = DEATH
	
func _on_Hurtbox_area_entered(area):
	var player_dmg:float = float(PlayerStats.damage)
	
	rng.randomize()
	# เปอร์เซนการแกว่งของ damage
	var inconstant_value_percent = round(rng.randf_range(3, 15))
	
	# คำนวน damge ที่โจมตีกับ monster
	var calculate_dmg = float(player_dmg * (100.0/(100.0 + def)))
	
	# จำนวนเปอร์เซนการลด
	var less_percent = float((calculate_dmg * float(inconstant_value_percent)) / 100)
	
	# total damage
	var dmg = (calculate_dmg - less_percent)
	
	var cri_rand = round(rng.randf_range(1, 100))
	#print( (30*100)/100 )
	if cri_rand <= PlayerStats.critical_rate:
		
		var cri = dmg * 2 
		
		var cri_percent_dmg = ( cri * PlayerStats.critical_damage ) / 100
		
		var total_dmg = cri + cri_percent_dmg
		
		health -= total_dmg
		create_effect_object.create_critical_floating_text(total_dmg)
	else:
		health -= dmg
		create_effect_object.create_floating_text(dmg)
		
	create_effect_object.create_hit_effect2()
	
	$HitSound.play(0)
	
	#update_healthbar()
	if health <= 0:
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 250

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
					#print(pos)
					#shoot(pos)
					shoot_magic(pos)
				break

func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
	
func shoot_magic(pos):
	var y = YellowThunder.instance()
	y.position = pos
	#get_parent().add_child(y)
	y.damage = atk
	get_tree().current_scene.add_child(y)
	can_shoot = false
	$ShootTimer.start()
		
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
	
func _on_Visibility_body_exited(body):
	
	if body == target:
		target = null
		state = IDLE

func _on_ShootTimer_timeout():
	can_shoot = true
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		can_shoot = true
		
