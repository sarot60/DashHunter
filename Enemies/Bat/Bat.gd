extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200

var is_death = false
var death_spent_time = 0

onready var blood1 = preload("res://Effects/BloodEffect1/BloodEffect1.tscn")

onready var create_effect_object = $CreateEffectObject

enum {
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone

# enemy stats
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var enemy_stats = {}

func _ready():
	
	enemy_stats = EnimyStats.get_enemy_stats("Bat")
	
	if enemy_stats.size() == 0: 
		playerDetectionZone.get_node("CollisionShape2D").disabled = true
		if has_node("Hitbox"):
			$Hitbox/CollisionShape2D.disabled = true
		return
		
	self.health = enemy_stats["max_hp"]
	max_speed = enemy_stats["speed"]
	atk = enemy_stats["atk"]
	def = enemy_stats["def"]
	
	$HpText/HealthBar.max_value = round(enemy_stats["max_hp"])
	$HpText/HealthBar.value = round(enemy_stats["max_hp"])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
		DEATH:
			if is_death:
				death_spent_time += delta
				if death_spent_time >= 2:
					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
	velocity = move_and_slide(velocity)
			
	
			
func set_health(value):
	health = value
	
	
func death():
	
	create_effect_object.create_death_effect()
	
	create_effect_object.create_drop_coin([1,3])
	
	var blood_instance = blood1.instance()
	blood_instance.global_position = global_position
	blood_instance.rotation = global_position.angle_to_point(Game.player.global_position)
	get_tree().current_scene.add_child(blood_instance)
	
	$AnimationPlayer.play("death")
	is_death = true
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$PlayerDetectionZone/CollisionShape2D.set_deferred("disabled", true)
	#$CollisionShape2D.set_deferred("disabled", true)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	state = DEATH
	
	
	# สุ่ม coin 1-3 เหรียญ
	create_effect_object.create_drop_coin([1,5])
	# ดรอปไอเทม ตามจำนวนในอาเรย์
	create_effect_object.create_item_drop(["Bat Wing", "Bat Wing"])
	
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


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
		
	if health <= 0:
		health = 0
		
	$HpText/HealthBar.value = health

	#create_effect_object.create_attack_line_effect(Vector2(0, -16))
	
	create_effect_object.create_hit_effect2(Vector2(0, -16))
	#create_effect_object.create_hit_effect(Vector2(0, -16))
	
	
	if health <= 0:
		death()
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 300
	
	

