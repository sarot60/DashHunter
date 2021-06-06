extends KinematicBody2D

var rng = RandomNumberGenerator.new()

# Emeny Move
export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 100
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

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

onready var create_effect_object = $CreateEffectObject

onready var playerDetectionZone = $PlayerDetectionZone

onready var anim_player = $AnimationPlayer

# enemy stats
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var enemy_stats = {}

func _ready():
	
	enemy_stats = EnimyStats.get_enemy_stats("DarkSpider")
	
	if enemy_stats.size() == 0: 
		playerDetectionZone.get_node("CollisionShape2D").disabled = true
		if has_node("Hitbox"):
			$Hitbox/CollisionShape2D.disabled = true
		return
		
	self.health = enemy_stats["max_hp"]
	max_speed = enemy_stats["speed"]
	atk = enemy_stats["atk"]
	def = enemy_stats["def"]

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
				play_anim("run")
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
	
	var tmp_death_sfx = $InsectDeathSFX.duplicate()
	tmp_death_sfx.global_position = global_position
	tmp_death_sfx.get_node("HitEffect").volume_db = -10
	tmp_death_sfx.get_node("HitEffect").play(0)
	tmp_death_sfx.play(0)
	get_tree().current_scene.add_child(tmp_death_sfx)
	
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
	create_effect_object.create_item_drop(["Iron Ore", "Yellow Gem", "Yellow Gem"])
	
	AddExperience.add_exp(5)
	
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
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	b.global_position = global_position + Vector2(-6, -6)
	b.damage = atk
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
