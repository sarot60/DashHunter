extends KinematicBody2D

var MOVE_SPEED = 120

enum {
	IDLE,
	MOVE,
}

var is_dash:bool = false
var dash_time:float = 0

var debug_delta_timer = 0

var time_to_start_attack = 0

onready var joystick = get_node("Control/Joystick/Joystick/JoystickButton")
onready var joystick_attack = get_node("Control/BottomRightButtonGroup/JoystickAttackButton/JoystickAttackButton")

onready var foot_step = preload("res://Effects/FootDust/FootDust.tscn")
onready var sword_eff = preload("res://Effects/SwordEffect/SwordEffect.tscn")

onready var sword = get_node("Weapon/Sword")
onready var weapon = get_node("Weapon")

var first_move = false

var direction = "right"

onready var anim_player = $AnimationPlayer

func _ready():
	Game.player = self
	#print(GameState.state)

func _physics_process(delta):

	var move_vec = Vector2()
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
		play_anim("run")
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
		play_anim("run")
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
		play_anim("run")
		# for testing ==========================================
		if joystick_attack.get_value() == Vector2.ZERO:
			direction = "left"
			flip()
		#========================================================
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		play_anim("run")
		# for testing ==========================================
		if joystick_attack.get_value() == Vector2.ZERO:
			direction = "right"
			flip()
		# ======================================================
	move_vec = move_vec.normalized()
	
	if joystick.get_value() != Vector2.ZERO:
		play_anim("run")
		move_vec = joystick.get_value()
		if joystick_attack.get_value() == Vector2.ZERO:
			if joystick.get_value().x > 0:
				direction = "right"
			else:
				direction = "left"
			flip()

	if Input.is_action_just_pressed("ui_space") and !is_dash and move_vec != Vector2.ZERO:
		dash()
	
	"""
	if Input.is_action_just_pressed("left_click"):
		if direction == "right":
			play_anim_attack("attack_right_1")
		elif direction == "left":
			play_anim_attack("attack_left_1")
	"""
	
	if joystick_attack.get_value() != Vector2.ZERO:
		if joystick_attack.get_value().x > 0 and $AnimationPlayerAttack.current_animation != "sword_attack":
			direction = "right"
		elif joystick_attack.get_value().x < 0 and $AnimationPlayerAttack.current_animation != "sword_attack":
			direction = "left"
		flip()
		
	#$test_rotation.look_at(get_global_mouse_position())
	if joystick_attack.get_value() != Vector2.ZERO:
		time_to_start_attack += delta
		if time_to_start_attack >= 0.2:
			
			#print(joystick_attack.get_value())
			
			var get_look_at = global_position + (Vector2(64, 64) * joystick_attack.get_value())
			$test_rotation.look_at( get_look_at )
			$HitBox.look_at( get_look_at )
			
			if direction == "right":
				#$Sword.position.x = 8
				#$Sword/Sword.flip_h = false
				weapon.scale.x = 1
				weapon.look_at( global_position + (Vector2(64, 64) * joystick_attack.get_value()) )
			else:
				#$Sword.position.x = -8
				#$Sword/Sword.flip_h = true	
				weapon.scale.x = -1
				weapon.look_at( global_position + Vector2(0, -16) + (Vector2(-64, -64) * joystick_attack.get_value()) )
			play_anim_attack("sword_attack")
			time_to_start_attack = 0
	else:
		time_to_start_attack = 0
		play_anim_attack("idle")
		$HitBox/SwordHitBox/CollisionShape2D.disabled = true
		if direction == "right":
			var get_look_at_right = global_position + Vector2(64, -8)
			#$test_rotation.look_at( get_look_at_right )
			$test_rotation.rotation_degrees = 0
			$HitBox.look_at( get_look_at_right )
			weapon.scale.x = 1
			weapon.look_at( global_position + Vector2(64, -8))

			
		else:
			var get_look_at_left = global_position + Vector2(-64, -8)
			#$test_rotation.look_at( get_look_at_left )
			$test_rotation.rotation_degrees = -180
			$HitBox.look_at( get_look_at_left )
			weapon.scale.x = -1
			weapon.look_at( global_position + Vector2(64, -8))

			
	#print($AnimationPlayerAttack.is_playing() and $AnimationPlayerAttack.current_animation == "sword_attack")
	
	if move_vec == Vector2.ZERO:
		play_anim("idle")
		
	if is_dash:
		dash_time += delta
		
		if dash_time <= 0.15:
			var ghost = preload("res://Effects/GhostEffect/GhostEffect.tscn").instance()
			get_parent().add_child(ghost)
			ghost.position = position
			if direction == "right":
				ghost.flip_h = false
			else:
				ghost.flip_h = true
				
		if dash_time >= 0.15:
			MOVE_SPEED = 120
		if dash_time >= 0.3:
			is_dash = false
			dash_time = 0
			
		
			
	if move_vec != Vector2.ZERO:
		if first_move:
			var footstep = foot_step.instance()
			footstep.emitting = true
			footstep.global_position = Vector2(global_position.x, global_position.y - 1)
			get_parent().add_child(footstep)
			first_move = false
		debug_delta_timer += delta
		if debug_delta_timer >= 0.3:
			var footstep = foot_step.instance()
			footstep.emitting = true
			footstep.global_position = Vector2(global_position.x, global_position.y - 1)
			get_parent().add_child(footstep)
			debug_delta_timer = 0
	else:
		debug_delta_timer = 0
		
	if move_vec == Vector2.ZERO and !first_move:
		first_move = true
		
	if move_vec.x > 0:
		#if $AnimationPlayerAttack.current_animation != "attack_right_1" and \
		#$AnimationPlayerAttack.current_animation != "attack_left_1":
		#	direction = "right"
#			flip()
		pass
	elif move_vec.x < 0:
		#if $AnimationPlayerAttack.current_animation != "attack_right_1" and \
		#$AnimationPlayerAttack.current_animation != "attack_left_1":
		#	direction = "left"
#			flip()
		pass
		
	move_and_slide(move_vec * MOVE_SPEED, Vector2())
	
"""
func attack_cursor(delta):

	if joystick_attack.ongoing_drag == -1:
		var pos_difference = (Vector2(32, 0) - joystick_attack.radius) - $CursorAttack/AttackCursor.position
		$CursorAttack/AttackCursor.position += pos_difference * joystick_attack.return_accel * delta
		
	var get_button_pos = joystick_attack.get_button_pos()
	
	if joystick_attack.ongoing_drag == 0 and get_button_pos.length() > joystick_attack.threshold+5:
		
		$CursorAttack/AttackCursor.set_position(joystick_attack.set_cursor)
		
		if get_button_pos.length() > joystick_attack.boundary:
			$CursorAttack/AttackCursor.set_position(joystick_attack.set_cursor)
"""


func dash() -> void:
	
	var dash_eff_explosion = preload("res://Effects/DashExplosion/DashExplosion.tscn").instance()
	dash_eff_explosion.position = position
	get_tree().current_scene.add_child(dash_eff_explosion)
	
	MOVE_SPEED = 500
	is_dash = true
	
func flip():
	if direction == "right":
		$Sprite.flip_h = false
#		$Sword.flip_h = false
#		$Sword.position.x = 8
		pass
	elif direction == "left":
		$Sprite.flip_h = true
#		$Sword.flip_h = true
#		$Sword.position.x = -8
		pass
		
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
	
func play_anim_attack(anim_name):
	if $AnimationPlayerAttack.is_playing() and $AnimationPlayerAttack.current_animation == anim_name:
		return
	$AnimationPlayerAttack.play(anim_name)
	if anim_name == "sword_attack":

		var sw_eff = sword_eff.instance()
		sw_eff.global_position = global_position
		sw_eff.rotation_degrees = $test_rotation.rotation_degrees
		get_parent().add_child(sw_eff)
	
func _on_DashButton_pressed():
	if is_dash or joystick.get_value() == Vector2.ZERO:
		return
	dash()


func _on_Hurtbox_area_entered(area):
	#print(GameState.state.current_health)
	pass

