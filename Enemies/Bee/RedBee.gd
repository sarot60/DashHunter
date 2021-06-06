extends KinematicBody2D

var rng = RandomNumberGenerator.new()

var ACCELERATION = 200
var FRICTION = 200
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

# enimy stats
var max_speed = 0
onready var health = 0 setget set_health
var atk = 0
var def = 0

var is_death = false
var death_spent_time = 0

onready var hurtbox = $Hurtbox

onready var create_effect_object = $CreateEffectObject

enum {
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
}
var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone

onready var anim_player = get_node("AnimationPlayer")

var enimy_name = "Bee"

var stats = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	stats = EnimyStats.get_enemy_stats("Bee")
	if stats.size() != 0:
		self.health = stats["max_hp"]
		max_speed = stats["speed"]
		atk = stats["atk"]
		def = stats["def"]
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			#play_anim("idle")
		WANDER:
			pass
			
		CHASE:
			
			var player = playerDetectionZone.player
			if player != null:
				#play_anim("move")
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
	
	#call_deferred("drop_coin")
	create_effect_object.create_drop_coin([1,3])
	create_effect_object.create_item_drop(["Aloe Vera Leaf"])
	
	AddExperience.add_exp(5)
	#AddExperience.add_exp(2)
	
	get_tree().call_group("need_red_bee_destroy", "update_red_bee_destroy", self)
	
	queue_free()

# -------------------------- Signal ------------------------------

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
	
	$HitSound.play(0)
	
	# hit effect
	#create_effect_object.create_hit_effect()
	create_effect_object.create_hit_effect2()
	
	update_healthbar()
	if health <= 0:
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 250
