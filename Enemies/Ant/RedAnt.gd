extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

var max_health = 100
onready var health = max_health setget set_health

var is_death = false
var death_spent_time = 0


enum {
	IDLE, # ยืน
	WANDER, # เดิน
	CHASE, # ไล่ล่า
	DEATH,
}

var can_attack = true

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone

onready var anim_player = get_node("AnimationPlayer")

onready var create_effect_object = $CreateEffectObject

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.value = health
	
	if has_node("Hitbox"):
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
	
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
				play_anim("move")
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
	$HealthBar.value = health

	
func death():


	create_effect_object.create_drop_coin([1,5])
	
	create_effect_object.create_death_effect()
	
	create_effect_object.create_blood_effect()
	
	state = DEATH
	
	queue_free()

# -------------------------- Signal ------------------------------

func _on_Hurtbox_area_entered(area):
	health -= 30
	
	create_effect_object.create_floating_text(30)
	
	create_effect_object.create_hit_effect2()

	update_healthbar()
	if health <= 0:
		death()
	
	if health > 0:
		create_effect_object.create_hit_effect3()
		
	var direction = (area.global_position - global_position).normalized()
	knockback = -direction * 250
