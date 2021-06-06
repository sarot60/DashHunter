extends KinematicBody2D

#signal enimy_dead

var MOVE_SPEED = 120

var is_death = false

var is_dash:bool = false
var dash_time:float = 0

var is_attack:bool = false

var first_move:bool = false
var foot_dust_delta_timer:float = 0.0

export var speed = 120
export var friction = 0.2
export var acceleration = 0.5

export(PackedScene) var dash_objecct

""" === skill
"""
export(PackedScene) var super_dash

var velocity = Vector2()

var facingDir:Vector2 = Vector2(0, 1) # default

onready var anim_player = get_node("AnimationPlayer")
onready var blink_anim_player = $BlinkAnimationPlayer

onready var joystick = get_node("Control/Joystick/Joystick/JoystickButton")

var max_health = 100
onready var health = max_health setget set_health

onready var hit_effect = preload("res://Effects/HitEffect/HitEffect.tscn")
onready var death_effect = preload("res://Effects/DeathEffect/DeathEffect.tscn")
onready var foot_dust = preload("res://Effects/FootDust/FootDust.tscn")

const STEP_RATE = 20 # change from 30
var cur_step_dist = 0
const footstep = preload("res://Effects/foot_step/foot_step.tscn")

func _ready():
	Game.player = self

	#self.global_position = Vector2(GameState.state.current_pos[0],GameState.state.current_pos[1])
	#self.global_position = Vector2(game_state.state.current_pos[0],game_state.state.current_pos[1])
	
	$Control/RightGroupButton/AttackButton.connect("pressed", self, "_on_AttackButton_pressed")
	$Control/RightGroupButton/DashButton.connect("pressed", self, "_on_DashButton_pressed")
	$Control/RightGroupButton/Skill1.connect("pressed", self, "_on_Skill1_pressed")
	$Control/RightGroupButton/Skill2.connect("pressed", self, "_on_Skill2_pressed")
	
	add_to_group("camera_shake")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
		facingDir = Vector2(1, 0)
	if Input.is_action_pressed('move_left'):
		input.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed('move_down'):
		input.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed('move_up'):
		input.y -= 1
		facingDir = Vector2(0, -1)
	
	if joystick.get_value() != Vector2.ZERO:
		#print(joystick.get_value())
		
		if joystick.get_value().x < 1 and joystick.get_value().y < -0.5:
			# up
			facingDir = Vector2(0, -1)
			#print("up")
			
		elif joystick.get_value().x < 0.8 and joystick.get_value().y > 0.5:
			# down
			facingDir = Vector2(0, 1)
			#print('down')
			
		elif joystick.get_value().x > 0.8 and joystick.get_value().y > -0.5:
			# right
			facingDir = Vector2(1, 0)
			#print('right')
			
		elif joystick.get_value().x < -0.8 and joystick.get_value().y < 0.8:
			# left
			facingDir = Vector2(-1, 0)
			#print("left") 
		
		return joystick.get_value()
	
	return input

var att_move_time:float = 0.0
var is_att_move:bool = false

var skill_1_move_time:float = 0.0
var skill_2_move_time:float = 0.0

func _physics_process(delta):
	
	$HeadDebug/HP.text = str(global_position)
	
	var direction = get_input()
	if direction.length() > 0 and not is_attack:
		velocity = lerp(velocity, direction.normalized() * MOVE_SPEED, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	
	
	""" === เคลื่อนที่ไปข้างหน้าเมื่อโจมตี
	"""
	if is_att_move:
		att_move_time += delta
		if att_move_time >= 0.03:
			if att_move_time <= 0.1:
				var _x = move_and_slide(direction * 350, Vector2())
		if att_move_time >= 0.2:
			att_move_time = 0
			is_att_move = false
	
#	if is_play_skill_1:
#		if skill_1_move_time >= 0.03:
#			if skill_1_move_time <= 0.1:
#				var _x = move_and_slide(direction * 350, Vector2())
#		if skill_1_move_time >= 0.2:
#			skill_1_move_time = 0
#			is_play_skill_1 = false
		
	if is_play_skill_2:
		skill_2_move_time += delta
		if skill_2_move_time >= 0.01:
			if skill_2_move_time <= 0.2:
				var _x = move_and_slide(direction * 800, Vector2())
		if skill_2_move_time >= 0.3:
			skill_2_move_time = 0
			is_play_skill_2 = false
	
	""" === ยืนปกติ
	"""
	if direction == Vector2.ZERO:
		if not is_attack:
			if facingDir == Vector2(0, -1):
				# idle up
				play_anim("idle_up")
			if facingDir == Vector2(0, 1):
				# idle down
				play_anim("idle_down")
			if facingDir == Vector2(-1, 0):
				# idle left
				play_anim("idle_left")
			if facingDir == Vector2(1, 0):
				# idle right
				play_anim("idle_right")
	else:
		if not is_attack:
			if facingDir == Vector2(0, -1):
				# up
				play_anim("run_up")
			if facingDir == Vector2(0, 1):
				# down
				play_anim("run_down")
			if facingDir == Vector2(-1, 0):
				# left
				play_anim("run_left")
			if facingDir == Vector2(1, 0):
				# right
				play_anim("run_right")
	
	""" === แดชหนีขณะโจมตี
	"""
	if Input.is_action_just_pressed("ui_space") and is_attack:
		if game_state.state.cur_stamina >= 20:
			#GameState.state.cur_stamina -= 30
			game_state.state.cur_stamina -= 20
			
			# call in health bar
			get_tree().call_group("update_bar", "update_stamina_bar", self)
			dash()
			
			is_attack = false
			
			$SwordFacing/SwordHitbox/CollisionPolygon2D.set_deferred("disabled", true)
		
	""" === ทำการแดช
	"""
	if Input.is_action_just_pressed("ui_space") and !is_dash and direction != Vector2.ZERO and !is_attack:
		#if GameState.state.cur_stamina >= 30:
		if game_state.state.cur_stamina >= 20:
			#GameState.state.cur_stamina -= 30
			game_state.state.cur_stamina -= 20
			
			# call in health bar
			get_tree().call_group("update_bar", "update_stamina_bar", self)
			dash()
	
	""" === กดโจมโจมตี
	"""
	if Input.is_action_just_pressed("attack") and !is_attack:
		sword_attack()
	
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
		if foot_dust_delta_timer >= 0.3:
			var foot_dust_obj = foot_dust.instance()
			foot_dust_obj.emitting = true
			foot_dust_obj.global_position = Vector2(global_position.x, global_position.y - 1)
			get_parent().add_child(foot_dust_obj)
			foot_dust_delta_timer = 0
	else:
		foot_dust_delta_timer = 0
	if direction == Vector2.ZERO and !first_move:
		first_move = true
	
	""" === เมื่อโจมตีเสร็จ
	"""
	if anim_player.is_playing() == false:
		is_attack = false
	
	
	""" === เคลื่อนที่แดช
	"""
	if is_dash:
		dash_time += delta
		
		if dash_time <= 0.15:
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
			
							
		if dash_time >= 0.15:
			MOVE_SPEED = 120
		if dash_time >= 0.3:
			is_dash = false
			dash_time = 0
		
	velocity = move_and_slide(velocity)
	
func dash() -> void:
	
	var dash_ins = dash_objecct.instance()
	add_child(dash_ins)
	dash_ins.emitting = true
	
	var dash_eff_explosion = preload("res://Effects/DashExplosion/DashExplosion.tscn").instance()
	dash_eff_explosion.position = position
	get_tree().current_scene.add_child(dash_eff_explosion)
	
	MOVE_SPEED = 500
	is_dash = true
	
	
func sword_attack():
	if facingDir == Vector2(0, -1):
		# attack up
		play_anim("sword_attack_up")
	if facingDir == Vector2(0, 1):
		# attack down
		play_anim("sword_attack_down")
	if facingDir == Vector2(1, 0):
		# right attack
		play_anim("sword_attack_right")
	if facingDir == Vector2(-1, 0):
		# left attack
		play_anim("sword_attack_left")
	
	is_att_move = true
	is_attack = true
	velocity = Vector2.ZERO

var is_play_skill_1:bool = false
func skill_1():
	is_play_skill_1 = true

var is_play_skill_2:bool = false
func skill_2():
	
	var dash_ins = super_dash.instance()
	add_child(dash_ins)
	dash_ins.emitting = true
	
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# call in Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [0.6, 20, 15, 1])
	
	is_play_skill_2 = true
	
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

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
	
func flip():
	pass
	
func set_health(value):
	health = value
	if health <= 0:
		is_death = true
		death()

func death():
	#GameState.state.cur_hp = 100
	#GameState.state.cur_sp = 100
	game_state.state.cur_hp = 100
	game_state.state.cur_sp = 100
	global_position = Vector2(0, 0)
	#queue_free()
	
	blink_anim_player.play("stop")
	
	
# -------------------------------- Signals -------------------------------

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
	
	if game_state.state.cur_stamina >= 30:
		#GameState.state.cur_stamina -= 30
		game_state.state.cur_stamina -= 30
			
		# call in health bar
		get_tree().call_group("update_bar", "update_stamina_bar", self)
		
		dash()


func _on_AttackButton_pressed():
	if is_attack: return
	sword_attack()

func _on_Hurtbox_area_entered(_area):
	
	var hit_eff_obj = hit_effect.instance()
	hit_eff_obj.global_position = position
	get_parent().add_child(hit_eff_obj)
	
	#GameState.state.cur_hp -= 10
	game_state.state.cur_hp -= 10
	
	#if GameState.state.cur_hp <= 0:
	if game_state.state.cur_hp <= 0:
		#GameState.state.cur_hp = 0
		game_state.state.cur_hp = 0
		
		is_death = true
		death()
		
	get_tree().call_group("update_bar", "update_all_bar", self)
	
	blink_anim_player.play("start")
	yield(get_tree().create_timer(0.5),"timeout")
	blink_anim_player.play("stop")


func _on_Skill1_pressed():
	skill_1()
	

func _on_Skill2_pressed():
	skill_2()
	

