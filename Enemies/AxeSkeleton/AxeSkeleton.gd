extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export var ACCELERATION = 200
export var FRICTION = 200
export var MAX_SPEED = 100

# enimy stats
var max_health = 30
onready var health = max_health setget set_health
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
	ATTACK
}

#var can_attack = true

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone

onready var anim_player = get_node("AnimationPlayer")

var target 

func _ready():
	
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
		
	if has_node("AttackArea"):
		var _Con2 = get_node("AttackArea").connect("body_entered", self, "_on_AttackArea_body_entered")
		var _Con4 = get_node("AttackArea").connect("body_exited", self, "_on_AttackArea_body_exited")
		
	var _Con3 = $AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

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
				play_anim("walk")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				flip(direction)
			else:
				state = IDLE
		DEATH:
			if is_death:
				death_spent_time += delta
				if death_spent_time >= 2:
					queue_free()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			pass
	velocity = move_and_slide(velocity)

func update_healthbar():
	pass

func set_health(value):
	health = value

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
	create_effect_object.create_item_drop(["Garlic", "Garlic"])
	
	AddExperience.add_exp(5)
	
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$AttackArea/CollisionShape2D.set_deferred("disabled", true)
	$PlayerDetectionZone/CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	
	play_anim("death")
	
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func flip(direction):
	if direction.x > 0:
		# ขวา
		$Sprite.scale.x = 1
	else:
		# ซ้าย
		$Sprite.scale.x = -1

# -------------------------- Signal ------------------------------

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
	#create_effect_object.create_hit_effect()
	create_effect_object.create_hit_effect2()
	
	update_healthbar()
	if health <= 0:
		death()
		
	if health > 0:
		create_effect_object.create_hit_effect3()
	
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 250

func _on_AttackArea_body_entered(body):
	if target != null: return
	target = body
	state = ATTACK
	play_anim("attack")
	yield(get_tree().create_timer(0.3),"timeout")
	
func _on_AttackArea_body_exited(body):
	if target:
		target = null

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		if target:
			$Hitbox/CollisionShape2D.set_deferred("disabled", false)
			play_anim("attack")
			state = ATTACK
			yield(get_tree().create_timer(0.3),"timeout")
			pass
		else:
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			#play_anim("flight")
			play_anim("idle")
			state = IDLE
			yield(get_tree().create_timer(0.3),"timeout")
			pass
	if anim_name == "death":
		queue_free()
		pass
