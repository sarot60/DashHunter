extends KinematicBody2D

#signal enimy_dead

# Player Movement
export var MOVE_SPEED:int = 150
export var DEFAULT_SPEED:int = 150
export var DASH_SPEED:int = 600
export var friction:float = 0.2
export var acceleration:float = 0.5

# Variable for check
var is_death:bool = false
var is_dash:bool = false
var dash_time:float = 0
var is_attack:bool = false
var attack_time_count:float = 0 
var attack_combo:int = 0

var cur_direction:Vector2 = Vector2(1, 1)

var first_move:bool = false
var foot_dust_delta_timer:float = 0.0

var att_move_time:float = 0.0
var is_att_move:bool = false

var skill_1_move_time:float = 0.0
var skill_2_move_time:float = 0.0


export(PackedScene) var dash_object:PackedScene
""" === skill
"""
export(PackedScene) var super_dash:PackedScene

var velocity = Vector2()

var facingDir:Vector2 = Vector2(0, 1) # default
var curFacing:String = "right"

onready var anim_player = get_node("AnimationPlayer")
onready var blink_anim_player = $BlinkAnimationPlayer

onready var joystick = get_node("Control/Joystick/Joystick/JoystickButton")

var max_health = 100
onready var health = max_health setget set_health

onready var hit_effect = preload("res://Effects/HitEffect/HitEffect.tscn")
onready var death_effect = preload("res://Effects/DeathEffect/DeathEffect.tscn")
onready var foot_dust = preload("res://Effects/FootDust/FootDust.tscn")

onready var hurtbox = $Hurtbox

const STEP_RATE = 20 # change from 30
var cur_step_dist = 0
const footstep = preload("res://Effects/foot_step/foot_step.tscn")

onready var create_effect_object = $CreateEffectObject

onready var play_skill = $PlaySkill

enum {
	IDLE,
	ATTACK,
	RUN,
	DASH,
	DEATH,
	USE_SKILL
}
var state = IDLE

""" -------------------------------------------------------------------------------------------------
"""

func _ready():
	Game.player = self
	
	var _Con1 = $Control/RightGroupButton/AttackButton.connect("pressed", self, "_on_AttackButton_pressed")
	var _Con2 = $Control/RightGroupButton/DashButton.connect("pressed", self, "_on_DashButton_pressed")
	
	var _Con3 = $Control/RightGroupButton/SkillSlot/Skill1.connect("pressed", self, "_on_Skill1_pressed")
	var _Con4 = $Control/RightGroupButton/SkillSlot/Skill2.connect("pressed", self, "_on_Skill2_pressed")
	#var _Con5 = $Control/RightGroupButton/SkillSlot/Skill3.connect("pressed", self, "_on_Skill3_pressed")
	
	add_to_group("camera_shake")
	add_to_group("player_create_effect")
	add_to_group("skill_change") # use from Skill / update_skill_slot

func get_input():
	# player move for pc
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
		facingDir = Vector2(1, 0)
		curFacing = "right"
	if Input.is_action_pressed('move_left'):
		input.x -= 1
		facingDir = Vector2(-1, 0)
		curFacing = "left"
	if Input.is_action_pressed('move_down'):
		input.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed('move_up'):
		input.y -= 1
		facingDir = Vector2(0, -1)
	
	# player move for mobile
	if joystick.get_value() != Vector2.ZERO:
		#print(joystick.get_value())
		
		if joystick.get_value().x < 1 and joystick.get_value().y < -0.5:
			# up
			facingDir = Vector2(0, -1)
			
		elif joystick.get_value().x < 0.8 and joystick.get_value().y > 0.5:
			# down
			facingDir = Vector2(0, 1)
			
		elif joystick.get_value().x > 0.8 and joystick.get_value().y > -0.5:
			# right
			facingDir = Vector2(1, 0)
			
		elif joystick.get_value().x < -0.8 and joystick.get_value().y < 0.8:
			# left
			facingDir = Vector2(-1, 0)
		
		return joystick.get_value()
	
	return input

func _physics_process(delta):
	
	$HeadDebug/HP.text = str(global_position)
	
	match state:
		IDLE:
			var direction = get_input()
			if direction != Vector2.ZERO:
				state = RUN
				
			""" === ยืนปกติ
			"""
			play_idle_animation()
				
			""" === กดโจมโจมตี
			"""
			if Input.is_action_just_pressed("attack"):
				sword_attack()
				
			velocity = lerp(velocity, Vector2.ZERO, friction)
		RUN:
			
			var direction = get_input()
			if direction == Vector2.ZERO:
				state = IDLE
			
			run_effect(delta, direction)
			play_run_animation()

			""" === ทำการแดช
			"""
			if Input.is_action_just_pressed("ui_space"):
				if PlayerStats.cur_stamina >= 20:
					PlayerStats.cur_stamina -= 20
					# call in health bar
					get_tree().call_group("update_bar", "update_stamina_bar", self)
					dash()
					
			velocity = lerp(velocity, direction.normalized() * MOVE_SPEED, acceleration)
		ATTACK:
			var direction = get_input()
			cur_direction = direction
			
#			if direction != Vector2.ZERO:
#				cur_direction = direction
			""" === เมื่อโจมตีเสร็จ
			"""
			if anim_player.is_playing() == false:
				att_move_time = 0
				is_att_move = false
				
				is_attack = false
				end_sword_attack()
				
			""" === แดชหนีขณะโจมตี
			"""
			if Input.is_action_just_pressed("ui_space"):
				if PlayerStats.cur_stamina >= 20:
					#GameState.state.cur_stamina -= 30
					PlayerStats.cur_stamina -= 20
					
					is_attack = false
					end_sword_attack()
					
					# call in health bar
					get_tree().call_group("update_bar", "update_stamina_bar", self)
					dash()
			
					$SwordFacing/SwordHitbox/CollisionPolygon2D.set_deferred("disabled", true)
					
			""" === เคลื่อนที่ไปข้างหน้าเมื่อโจมตี
			"""
			att_move_time += delta
			if att_move_time >= 0.03:
				if att_move_time <= 0.1:
					if direction != Vector2.ZERO:
						if attack_combo == 1:
							var _x = move_and_slide(direction.normalized() * 400, Vector2())
						elif attack_combo == 0:
							var _x = move_and_slide(direction.normalized() * 700, Vector2())
					elif direction == Vector2.ZERO:
						var _x = move_and_slide(cur_direction.normalized() * 80, Vector2())
			if att_move_time >= 0.5:
				att_move_time = 0
				is_att_move = false
		DASH:
			var direction = get_input()
			
			play_run_animation()
				
			""" === เคลื่อนที่แดช
			"""
			dash_time += delta
			if dash_time <= 0.15:
				ghost_effect()
			if dash_time >= 0.15:
				MOVE_SPEED = DEFAULT_SPEED
			if dash_time >= 0.3:
				dash_time = 0
				state = IDLE
			
			velocity = lerp(velocity, direction.normalized() * MOVE_SPEED, acceleration)
		USE_SKILL:
			var direction = get_input()
			
			#play_run_animation()
			play_idle_animation()
			
			play_skill.play_skill(delta, direction)
			
#			if is_play_skill_slot_2:
#				skill_2_move_time += delta
#				if skill_2_move_time >= 0.01:
#					if skill_2_move_time <= 0.2:
#						var _x = move_and_slide(direction.normalized() * 800, Vector2())
#				if skill_2_move_time >= 0.3:
#					skill_2_move_time = 0
#					is_play_skill_slot_2 = false
#
#					state = IDLE
			
			velocity = lerp(velocity, Vector2.ZERO, friction)
		DEATH:
			pass
	
#	var direction = get_input()
	
#	if direction != Vector2.ZERO and !is_attack:
#		cur_direction = direction
		
#	if direction.length() > 0:
#		velocity = lerp(velocity, direction.normalized() * MOVE_SPEED, acceleration)
#	else:
#		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
func dash() -> void:
	
	$dash_sfx.play()
	
	var dash_ins = dash_object.instance()
	add_child(dash_ins)
	dash_ins.emitting = true
	
	var dash_eff_explosion = preload("res://Effects/DashExplosion/DashExplosion.tscn").instance()
	dash_eff_explosion.position = position
	get_tree().current_scene.add_child(dash_eff_explosion)
	
	MOVE_SPEED = DASH_SPEED # change from 500
	is_dash = true
	
	att_move_time = 0
	
	is_att_move = false
	is_attack = false
	end_sword_attack()
	velocity = Vector2.ZERO
	
	attack_combo = 0
	
	state = DASH
	
func run_effect(delta, direction):
	""" === รอยเท้า
	"""
	if direction != Vector2.ZERO:
		cur_step_dist += MOVE_SPEED * delta
		if cur_step_dist > STEP_RATE:
			cur_step_dist -= STEP_RATE
			step()
	
	""" === ฝุ่นใต้ตีน
	"""
	if direction != Vector2.ZERO:
		if first_move:
			var foot_dust_obj = foot_dust.instance()
			foot_dust_obj.emitting = true
			foot_dust_obj.global_position = Vector2(global_position.x, global_position.y - 1)
			get_parent().add_child(foot_dust_obj)
			first_move = false
		foot_dust_delta_timer += delta
		if foot_dust_delta_timer >= 0.15:
			var foot_dust_obj = foot_dust.instance()
			foot_dust_obj.emitting = true
			foot_dust_obj.global_position = Vector2(global_position.x, global_position.y - 1)
			get_parent().add_child(foot_dust_obj)
			foot_dust_delta_timer = 0
	else:
		foot_dust_delta_timer = 0
		
	if direction == Vector2.ZERO and !first_move:
		first_move = true

func sword_attack():
	$sword_sfx.play()
	if facingDir == Vector2(0, -1):
		# attack up
		#play_anim("sword_attack_up")
		if $Sprite.scale.x == 1:
			if attack_combo == 0:
				play_anim("sword_attack_right")
				attack_combo = 1
			elif attack_combo == 1:
				play_anim("sword_combo_2_right")
				attack_combo = 0
				attack_time_count = 0
		else:
			if attack_combo == 0:
				play_anim("sword_attack_left")
				attack_combo = 1
			elif attack_combo == 1:
				play_anim("sword_combo_2_left")
				attack_combo = 0
				attack_time_count = 0
	if facingDir == Vector2(0, 1):
		# attack down
		#play_anim("sword_attack_down")
		if $Sprite.scale.x == -1:
			if attack_combo == 0:
				play_anim("sword_attack_left")
				attack_combo = 1
			elif attack_combo == 1:
				play_anim("sword_combo_2_left")
				attack_combo = 0
				attack_time_count = 0
		else:
			if attack_combo == 0:
				play_anim("sword_attack_right")
				attack_combo = 1
			elif attack_combo == 1:
				play_anim("sword_combo_2_right")
				attack_combo = 0
				attack_time_count = 0
	if facingDir == Vector2(1, 0):
		# right attack
		if attack_combo == 0:
			play_anim("sword_attack_right")
			attack_combo = 1
		elif attack_combo == 1:
			play_anim("sword_combo_2_right")
			attack_combo = 0
			attack_time_count = 0
	if facingDir == Vector2(-1, 0):
		# left attack
		if attack_combo == 0:
			play_anim("sword_attack_left")
			attack_combo = 1
		elif attack_combo == 1:
			play_anim("sword_combo_2_left")
			attack_combo = 0
			attack_time_count = 0
			
	is_att_move = true
	is_attack = true
	velocity = Vector2.ZERO
	
	if is_dash:
		dash_time = 0
		is_dash = false
	MOVE_SPEED = DEFAULT_SPEED

	$AttackTrail.show()
	
	$AttackComboTimer.set_wait_time(1)
	$AttackComboTimer.start()
	
	state = ATTACK

func end_sword_attack():
	$AttackTrail.hide()
	state = IDLE

#var is_play_skill_slot_1:bool = false
#func play_skill_slot_1():
#	is_play_skill_slot_1 = true
#
#var is_play_skill_slot_2:bool = false
#func play_skill_slot_2():
#
#	var current_skill
#
#	var dash_ins = super_dash.instance()
#	add_child(dash_ins)
#	dash_ins.emitting = true
#
#	# duration ระยะเวลา
#	# frequency ความถี่
#	# amplitude ความกว้าง
#	# priority ลำดับ ตัวเลขมากทำก่อน
#	# call in Player3 or Other Player
#	get_tree().call_group("camera_shake", "camera_shake", [0.6, 20, 15, 1])
#
#	is_play_skill_slot_2 = true
#	state = USE_SKILL
#
#var is_play_skill_slot_3:bool = false
#func play_skill_slot_3():
#	is_play_skill_slot_3 = true
#	pass
	
var left_step = true
func step():
	left_step = !left_step
	var f = footstep.instance()
	f.add_to_group("delete_on_restart")
	get_tree().get_root().add_child(f)
	get_tree().get_root().move_child(f, 0)
	var step_spot = $RStep.global_position
	if left_step:
		step_spot = $LStep.global_position
	f.global_position = step_spot
	#var steps = [step1, step2, step3]
	#var cur_step = randi() % 3
	#$step_player.stream = steps[cur_step]
	#$step_player.play()

func ghost_effect():
	var ghost = preload("res://Effects/GhostEffect/GhostEffect.tscn").instance()
	get_parent().add_child(ghost)
	ghost.position = position
#			if direction == "right":
#				ghost.flip_h = false
#			else:
#				ghost.flip_h = true
	if facingDir == Vector2(0, -1):
		# up
		ghost.flip_h = false
	if facingDir == Vector2(0, 1):
		# down
		ghost.flip_h = false
	if facingDir == Vector2(-1, 0):
		# left
		ghost.flip_h = true
	if facingDir == Vector2(1, 0):
		# right
		ghost.flip_h = false

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
	
func flip():
	if $Sprite.scale.x == 1:
		$Sprite.scale.x = -1
	elif $Sprite.scale.x == -1:
		$Sprite.scale.x = 1
	
func set_health(value):
	health = value
	if health <= 0:
		is_death = true
		death()

func play_idle_animation():
	if facingDir == Vector2(0, -1):
		# idle up
		play_anim("idle")
	if facingDir == Vector2(0, 1):
		# idle down
		play_anim("idle")
	if facingDir == Vector2(-1, 0):
		# idle left
		play_anim("idle")
	if facingDir == Vector2(1, 0):
		# idle right
		play_anim("idle")
		
func play_run_animation():
	if facingDir == Vector2(0, -1):
		# up
		if curFacing == "right":
			$Sprite.scale.x = 1
		else:
			$Sprite.scale.x = -1
		play_anim("run")
	if facingDir == Vector2(0, 1):
		# down
		if curFacing == "right":
			$Sprite.scale.x = 1
		else:
			$Sprite.scale.x = -1
		play_anim("run")
	if facingDir == Vector2(-1, 0):
		# left
		$Sprite.scale.x = -1
		play_anim("run")
	if facingDir == Vector2(1, 0):
		# right
		$Sprite.scale.x = 1
		play_anim("run")
	
func death():
	# Call to GreenVetaDungeonXXX.gd
	get_tree().call_group("player_died", "player_died", self)
	
	#GameState.state.cur_hp = 100
	#GameState.state.cur_sp = 100
	PlayerStats.cur_hp = PlayerStats.max_hp
	PlayerStats.cur_sp = PlayerStats.max_sp
	
	game_state.state.cur_hp = PlayerStats.max_hp
	game_state.state.cur_sp = PlayerStats.max_sp

	global_position = Vector2(0, 0)
	#queue_free()
	
	blink_anim_player.play("stop")
	
func player_create_heal_effect(_param):
	create_effect_object.create_heal_effect()

# -------------------------------- Signals -------------------------------

func update_skill_slot(_s):
	$Control/RightGroupButton.initialize_skill_slot()
	pass

func camera_shake(param):
	# ระยะเวลา
	var dura = param[0]
	
	# ความถี่
	var freq = param[1]
	
	# แอมพลิจูด ความกว้าง
	var ampl = param[2]
	
	# ลำดับความสำคัญ ตัวเลขมากทำก่อน
	var prio = param[3]
	
	$Camera2D/ScreenShake.start(dura, freq, ampl, prio)
	
func _on_DashButton_pressed():
	if is_dash or joystick.get_value() == Vector2.ZERO or is_attack:
		return
	
	if PlayerStats.cur_stamina >= 20:
		#GameState.state.cur_stamina -= 30
		PlayerStats.cur_stamina -= 20
			
		# call in health bar
		get_tree().call_group("update_bar", "update_stamina_bar", self)
		
		dash()


func _on_AttackButton_pressed():
	#if is_attack: return
	if state == ATTACK: return
	
	if facingDir == Vector2(0, -1):
		# up
		if curFacing == "right":
			$Sprite.scale.x = 1
		else:
			$Sprite.scale.x = -1
	if facingDir == Vector2(0, 1):
		# down
		if curFacing == "right":
			$Sprite.scale.x = 1
		else:
			$Sprite.scale.x = -1
	if facingDir == Vector2(-1, 0):
		# left
		$Sprite.scale.x = -1
	if facingDir == Vector2(1, 0):
		# right
		$Sprite.scale.x = 1
		
	sword_attack()

func _on_Hurtbox_area_entered(area):
	
	$hurt_sfx.play(0)
	
	hurtbox.start_invincibility(1)
	
	
	
	var hit_eff_obj = hit_effect.instance()
	hit_eff_obj.global_position = position
	get_parent().add_child(hit_eff_obj)

	if area.damage <= 0:
		return
	
	#GameState.state.cur_hp -= 10
	#game_state.state.cur_hp -= area.damage
	
	var dmg_cal = PlayerStats.take_damage(area.damage)
	
	create_effect_object.create_floating_text(dmg_cal)
	
	#if GameState.state.cur_hp <= 0:
	if PlayerStats.cur_hp <= 0:
		#GameState.state.cur_hp = 0
		PlayerStats.cur_hp = 0
		game_state.state.cur_hp = PlayerStats.cur_hp
		
		is_death = true
		death()
		
	# Call to HealthBar.gd
	get_tree().call_group("update_bar", "update_all_bar")
	
	blink_anim_player.play("start")
	yield(get_tree().create_timer(0.5),"timeout")
	blink_anim_player.play("stop")

var is_play_skill = false

func _on_Skill1_pressed():
	if state == DASH: return
	var skill = play_skill.get_skill(0)
	if skill != null and !is_play_skill:
		is_play_skill = true
		play_skill.initialize_skill(skill)
		state = USE_SKILL
		
func _on_Skill2_pressed():
	if state == DASH: return
	var skill = play_skill.get_skill(1)
	if skill != null and !is_play_skill:
		is_play_skill = true
		play_skill.initialize_skill(skill)
		state = USE_SKILL
	
#func _on_Skill3_pressed():
#	var skill = play_skill.get_skill(2)
#	if skill != null and !is_play_skill:
#		is_play_skill = true
#		play_skill.initialize_skill(skill)
#		state = USE_SKILL
		

func _on_AttackComboTimer_timeout():
	attack_combo = 0
