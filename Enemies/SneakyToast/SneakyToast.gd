extends KinematicBody2D

var rng = RandomNumberGenerator.new()

# Emeny Move
var ACCELERATION = 200
var FRICTION = 200
var MAX_SPEED = 100
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

# State
enum {
	HIDE,
	HIDDEN,
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
} 
var state = HIDE

# Variable for check
var is_death = false
var death_spent_time = 0

# Call Child Node
onready var playerDetectionZone = $PlayerDetectionZone
onready var create_effect_object = $CreateEffectObject
onready var anim_player = $AnimationPlayer

# enemy stats
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var stats = {}

func _ready():
	
	stats = EnimyStats.get_enemy_stats("SneakyToast")
	if stats.size() != 0:
		self.health = stats["max_hp"]
		max_speed = stats["speed"]
		atk = stats["atk"]
		def = stats["def"]
		
	if has_node("Hitbox"):
		$Hitbox.damage = atk
		
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
	
	set_physics_process(false)
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		HIDE:
			seek_player()
			play_anim("hide")
		HIDDEN:
			seek_player()
			play_anim("hidden")
			$Emotion.show()
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			play_anim("idle")
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				#play_anim("move")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				
				flip(direction)
				play_anim("walk")
				$Emotion.hide()
			else:
				play_anim("idle")
				state = IDLE
				set_physics_process(false)
		DEATH:
			if is_death:
				death_spent_time += delta
				if death_spent_time >= 2:
					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
	velocity = move_and_slide(velocity)

func set_health(value):
	health = value
	
func seek_player():
	if playerDetectionZone.can_see_player():
		if state == IDLE:
			state = CHASE
			return
		state = HIDDEN
		
			
func flip(direction):
	if direction.x > 0:
		# ขวา
		$Sprite.scale.x = 1
	else:
		# ซ้าย
		$Sprite.scale.x = -1

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


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
	
	create_effect_object.create_drop_coin([1,3])
	create_effect_object.create_item_drop(["Blank Paper", "Blank Paper", "Red Gem", "Red Gem"])
	
	AddExperience.add_exp(10)
	
	queue_free()

# ---------------------------- Signals --------------------------------

func _on_Hurtbox_area_entered(area):
	
	$HitSound.play()
	
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
	
	# hit effect
	#create_effect_object.create_hit_effect()
	create_effect_object.create_hit_effect2()
	
	#update_healthbar()
	if health <= 0:
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 250


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hidden":
		state = CHASE
