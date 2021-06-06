extends KinematicBody2D

var rng = RandomNumberGenerator.new()

var ACCELERATION = 200
var FRICTION = 200
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var is_death = false
var death_spent_time = 0

enum {
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
}
var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var create_effect_object = $CreateEffectObject
onready var anim_player = get_node("AnimationPlayer")

# enemy stats
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var enemy_stats = {}

func _ready():
		
	enemy_stats = EnimyStats.get_enemy_stats("BabyBoxer")
	
	if enemy_stats.size() == 0: 
		playerDetectionZone.get_node("CollisionShape2D").disabled = true
		if has_node("Hitbox"):
			$Hitbox/CollisionShape2D.disabled = true
		return
		
	self.health = enemy_stats["max_hp"]
	max_speed = enemy_stats["speed"]
	atk = enemy_stats["atk"]
	def = enemy_stats["def"]
	
	if has_node("DisabledHitboxTimer"):
		var _tmp1 = $DisabledHitboxTimer.connect("timeout", self, "_on_DisabledHitboxTimer_timeout")
	
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
				velocity = velocity.move_toward(direction * max_speed, ACCELERATION * delta)
			else:
				state = IDLE
		DEATH:
			if is_death:
				death_spent_time += delta
				if death_spent_time >= 2:
					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
	velocity = move_and_slide(velocity)
	
	
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func set_health(value):
	health = value

func update_healthbar():
	#$HealthBar.value = health
	pass
	

func death():
	
	create_effect_object.create_death_effect()
	
	state = DEATH
	
	create_effect_object.create_attack_line_effect()
	
	create_effect_object.create_blood_effect()
	
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# call in Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [0.2, 15, 10, 0])
	
	# สุ่ม coin 1-3 เหรียญ
	create_effect_object.create_drop_coin([1,5])
	# ดรอปไอเทม ตามจำนวนในอาเรย์
	create_effect_object.create_item_drop(["Insect Feet", "Insect Feet", "Insect Feet", "Heart"])
	
	AddExperience.add_exp(5)

	queue_free()

# -------------------------- Signal ------------------------------

func _on_Hurtbox_area_entered(area):
	
	$HitSound.play()
	
	# attack*(100/(100+defense))
	
	#var d = round(30 + (100/100 + def))
	#var less_percent = (d * inconstant_value_percent) / 100
	#var total_dmg = round(d - less_percent)
	#print( "damage = ", total_dmg )
	
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
	
	update_healthbar()
	if health <= 0:
		
		var tmp_death_sfx = $InsectDeathSFX.duplicate()
		tmp_death_sfx.global_position = global_position
		tmp_death_sfx.get_node("HitEffect").play(0)
		tmp_death_sfx.get_node("HitEffect").volume_db = -10
		tmp_death_sfx.play(0)
		get_tree().current_scene.add_child(tmp_death_sfx)
		
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()
		
	if has_node("DisabledHitboxTimer"):
		if has_node("Hitbox") and has_node("Hurtbox"):
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$DisabledHitboxTimer.set_wait_time(0.5)
		$DisabledHitboxTimer.start()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 300
	
func _on_DisabledHitboxTimer_timeout():
	if has_node("Hitbox") and has_node("Hurtbox"):
		$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", false)


var is_poke = false
func _on_PlayerDetectionForHide_body_entered(_body):
	play_anim("hide")
	
func _on_PlayerDetectionForHide_body_exited(_body):
	play_anim("idle")
	$Sprite.show()
	is_poke = false

func _on_PlayerDetectionForPoke_body_entered(_body):
	if !is_poke:
		play_anim("poke")
		$Sprite.show()
		is_poke = true
	else:
		play_anim("idle")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		$Sprite.hide()
	if anim_name == "poke":
		play_anim("idle")
		
