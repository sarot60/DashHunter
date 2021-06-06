extends KinematicBody2D

var rng = RandomNumberGenerator.new()

# Emeny Move
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 100
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

# Enemy Stats
var max_health = 100
onready var health = max_health setget set_health
var atk = 0
var def = 0

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
	
	FLY,
	TAKE_FLY,
	TAKE_FALL
}
var state = IDLE

onready var create_effect_object = $CreateEffectObject

onready var playerDetectionZone = $PlayerDetectionZone

onready var anim_player = $AnimationPlayer

func _ready():
	
	$ShootTimer.wait_time = fire_rate
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
		
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			play_anim("idle")
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				
				flip(direction)
				#play_anim("walk")
			else:
				play_anim("idle")
				state = IDLE
				set_physics_process(false)
		ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			update()
			if target:
				var direction = (target.global_position - global_position).normalized()
				flip(direction)
				aim()
		DEATH:
			if is_death:
				death_spent_time += delta
				if death_spent_time >= 2:
					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
	velocity = move_and_slide(velocity)

func set_health(value):
	health = value
	
func flip(direction):
	if direction.x > 0:
		# ขวา
		$Sprite.scale.x = 1
	else:
		# ซ้าย
		$Sprite.scale.x = -1
	
func death():
	state = DEATH
	
	create_effect_object.create_death_effect()
	
	create_effect_object.create_attack_line_effect()
	
	create_effect_object.create_blood_effect()
	
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# call in Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [0.2, 15, 10, 0])
	
	create_effect_object.create_drop_coin([1,3])
	create_effect_object.create_item_drop(["Aloe Vera Leaf", "Mint Leaf", "Yellow Gem"])
	
	AddExperience.add_exp(5)
	
	get_tree().call_group("need_boss_ref", "boss_death", true)
	
	queue_free()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

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
	#for angle in [ -1.2, -0.8, -0.4, 0, 0.4, 0.8, 1.2 ]:
	for angle in [ 0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200]:
		var b = Bullet.instance()
		var a = (pos - global_position).angle()
		#b.start(global_position, a + rand_range(-0.05, 0.05) + angle)
		b.start(global_position, a + angle)
		
		b.global_position = global_position + Vector2(-6, -24)
		#b.global_position = $Sprite/SpllPosition.global_position
		
		#spread
		
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
	

	
# ------------------------ Signals ------------------------
func _on_Hurtbox_area_entered(area):
	# เปอร์เซนการแกว่งของ damage
	rng.randomize()
	var inconstant_value_percent = round(rng.randf_range(3, 15))
	var d = round(30 + (100/100 + def))
	var less_percent = (d * inconstant_value_percent) / 100
	var total_dmg = round(d - less_percent)
	#print( "damage = ", total_dmg )
	
	health -= total_dmg
	create_effect_object.create_floating_text(total_dmg)
	
	# hit effect
	create_effect_object.create_hit_effect2()
	
	create_effect_object.create_attack_line_effect()
	
	# call to GreenVetaDungionXXX.gd
	get_tree().call_group("need_boss_ref", "set_boss_hp", health)
	
	#update_healthbar()
	if health <= 0:
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 250


func _on_ShootZone_body_entered(body):
	if target:
		return
	target = body
	state = ATTACK
	
	first_detect = true
	
	play_anim("idle")
	

func _on_ShootZone_body_exited(body):
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

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		can_shoot = true
