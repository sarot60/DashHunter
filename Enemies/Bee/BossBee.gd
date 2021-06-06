extends KinematicBody2D

var rng = RandomNumberGenerator.new()


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
	FLY,
	IDLE,
	TAKE_FLY,
	TAKE_FALL,
	DEATH
}

var state = FLY

onready var hit_effect = preload("res://Effects/HitEffect/HitEffect.tscn")
onready var death_effect = preload("res://Effects/DeathEffect/DeathEffect.tscn")

onready var anim_player = $AnimationPlayer

onready var create_effect_object = $CreateEffectObject

var red_bee_destroy = 0

# enemy stats
var max_health = 0
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var enemy_stats = {}

func _ready():
	
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	#$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	
	enemy_stats = EnimyStats.get_enemy_stats("BossBee")
	
	if enemy_stats.size() == 0: 
		if has_node("Hitbox"):
			$Hitbox/CollisionShape2D.disabled = true
		return
	
	self.health = enemy_stats["max_hp"]
	max_health = enemy_stats["max_hp"]
	max_speed = enemy_stats["speed"]
	atk = enemy_stats["atk"]
	def = enemy_stats["def"]
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Call from RedBee.gd
	add_to_group("need_red_bee_destroy")
	
	#########################################################################
	yield(get_tree(), "idle_frame")
	get_tree().call_group("need_boss_ref", "set_boss", self)
	#########################################################################
	
	#$FallTimer.set_wait_time(5)
	#$FallTimer.start()
	
func _physics_process(_delta):
	match state:
		FLY:
			# attak player
			update()
			if target:
				aim()
				var direction = (target.global_position - global_position).normalized()
				
				flip(direction)
		IDLE:
			pass
		TAKE_FLY:
			pass
		TAKE_FALL:
			pass
		DEATH:
			pass
	
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)

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
	
	create_effect_object.create_drop_coin([10,20])
	create_effect_object.create_item_drop(["Insect Feet", "Insect Feet", "Insect Feet", "Insect Feet", "Yellow Gem", "Yellow Gem"])
	
	AddExperience.add_exp(500)
	
	get_tree().call_group("need_boss_ref", "boss_death", true)
	
	queue_free()

func set_health(value):
	health = value

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
	#for pos in [target.position]:
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
	for angle in [ 0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200]:
		var b = Bullet.instance()
		var a = (pos - global_position).angle()
		#b.start(global_position, a + rand_range(-0.05, 0.05) + angle)
		b.start(global_position, a + angle)
		
		b.global_position = global_position + Vector2(-6, -24)
		b.damage = atk
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
			
# Group need_red_bee_destroy / Call from RedBee.gd
func update_red_bee_destroy(_param):
	red_bee_destroy += 1
	if red_bee_destroy == 3:
		take_fall()
		red_bee_destroy = 0
		
func create_red_bee():
	var red_bee_class = load("res://Enemies/Bee/RedBee.tscn")
	for i in [-60,10,60]:
		var red_bee_obj = red_bee_class.instance()
		red_bee_obj.global_position = global_position + Vector2(i, 0)
		get_parent().add_child(red_bee_obj)
		
# ------------------ do state ----------------
func idle():
	state = IDLE
	play_anim("idle")
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	$CollisionShape2D.set_deferred("disabled", false)
	
func fly():
	state = FLY
	play_anim("fly")
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	
func take_fly():
	state = TAKE_FLY
	play_anim("take_fly")
	#$FallTimer.set_wait_time(3)
	#$FallTimer.start()
	
	create_red_bee()
	
	#get_tree().call_group("boss_bee_take_fly", "boss_bee_take_fly", "boss_take_fly")
	
func take_fall():
	state = TAKE_FALL
	play_anim("take_fall")
	$TakeFlyTimer.set_wait_time(5)
	$TakeFlyTimer.start()
	
# ----------------------------- Signal -----------------------------

func _on_TakeFlyTimer_timeout():
	take_fly()

func _on_FallTimer_timeout():
	take_fall()

func _on_Hurtbox_area_entered(_area):
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
		
	$HitSound.play(0)
	
	# hit effect
	#create_effect_object.create_hit_effect()
	create_effect_object.create_hit_effect2()
	
	# call to GreenVetaDungionXXX.gd
	get_tree().call_group("need_boss_ref", "set_boss_hp", health)
	
	if health <= 0:
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()

	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "take_fly":
		fly()
	elif anim_name == "take_fall":
		idle()


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body


func _on_Visibility_body_exited(body):
	if body == target:
		target = null


func _on_ShootTimer_timeout():
	can_shoot = true
