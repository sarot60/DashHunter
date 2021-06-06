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
	SUMMON,
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
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
		
	if has_node("AttackArea"):
		var _Con2 = get_node("AttackArea").connect("body_entered", self, "_on_AttackArea_body_entered")
		var _Con3 = get_node("AttackArea").connect("body_exited", self, "_on_AttackArea_body_exited")
		
	var _Con4 = $AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

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
				play_anim("walk")
				flip(direction)
			else:
				state = IDLE
		DEATH:
#			if is_death:
#				death_spent_time += delta
#				if death_spent_time >= 2:
#					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		SUMMON:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
			
	velocity = move_and_slide(velocity)

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
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func set_health(value):
	health = value

func update_healthbar():
	#$HealthBar.value = health
	pass
	
func death():
	is_death = true
	
	var tmp_death_sfx = $InsectDeathSFX.duplicate()
	tmp_death_sfx.global_position = global_position
	tmp_death_sfx.get_node("HitEffect").volume_db = -10
	tmp_death_sfx.get_node("HitEffect").play(0)
	tmp_death_sfx.play(0)
	get_tree().current_scene.add_child(tmp_death_sfx)
	
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
	
	# สุ่ม coin 1-3 เหรียญ
	create_effect_object.create_drop_coin([1,5])
	# ดรอปไอเทม ตามจำนวนในอาเรย์
	create_effect_object.create_item_drop(["Mushroom", "Blank Paper", "Blank Paper", "Blank Paper"])
	
	AddExperience.add_exp(50)
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	play_anim("death")

# -------------------------- Signal ------------------------------

func _on_Hurtbox_area_entered(area):
	if is_death: return
	if !waiting_summon:
	
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
		#create_effect_object.create_hit_effect()
		create_effect_object.create_hit_effect2()
		
		update_healthbar()
		if health <= 0:
			death()
			
		if health > 0:
			create_effect_object.create_hit_effect3()
		
		var direction = (area.global_position - global_position).normalized()
		knockback = -direction * 300

var is_summon = false
var waiting_summon = false
func _on_AttackArea_body_entered(_body):
	if is_death: return
	if waiting_summon: return
	if !is_summon:
		play_anim("summon")
		state = SUMMON
		is_summon = true

func _on_AttackArea_body_exited(_body):
	if is_death: return
	if waiting_summon: return
	state = IDLE
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "summon":
		waiting_summon = true
		var baby_boxer_class = load("res://Enemies/BabyBoxer/BabyBoxer.tscn")
		
		$Summon.play()
		
		$GateEffect.start()
		$GateEffect2.start()
		$GateEffect3.start()
		$GateEffect4.start()
		yield(get_tree().create_timer(0.5),"timeout")
		
		var baby_boxer_obj1 = baby_boxer_class.instance()
		baby_boxer_obj1.global_position = $GateEffect.global_position + Vector2(0, 16)
		get_parent().add_child(baby_boxer_obj1)
		
		var baby_boxer_obj2 = baby_boxer_class.instance()
		baby_boxer_obj2.global_position = $GateEffect2.global_position + Vector2(0, 16)
		get_parent().add_child(baby_boxer_obj2)
		
		var baby_boxer_obj3 = baby_boxer_class.instance()
		baby_boxer_obj3.global_position = $GateEffect3.global_position + Vector2(0, 16)
		get_parent().add_child(baby_boxer_obj3)
		
		var baby_boxer_obj4 = baby_boxer_class.instance()
		baby_boxer_obj4.global_position = $GateEffect4.global_position + Vector2(0, 16)
		get_parent().add_child(baby_boxer_obj4)
		
		yield(get_tree().create_timer(2),"timeout")
		waiting_summon = false
		state = IDLE
		
	if anim_name == "death":
		yield(get_tree().create_timer(1),"timeout")
		queue_free()
