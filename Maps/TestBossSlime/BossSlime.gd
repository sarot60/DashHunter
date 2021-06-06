extends KinematicBody2D

export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

var target
var hit_pos
var can_shoot = true

#export(String, "friendly", "prey", "predator") var role

export(String, "idle", "shoot_att", "jump_att") var att_state:String = "idle"

var jump_cooldown:float = 5.0
var can_jump_att:bool = true
var target_pos:Vector2 = Vector2.ZERO


var is_shoot_att:bool = true

enum AI_STATE {
	IDLE,
	WALK,
	JUMP,
	SHOOT
}
var state:int = AI_STATE.JUMP

func _ready():
	$Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	

func _physics_process(delta):
	match state:
		AI_STATE.IDLE:
			pass
		
		AI_STATE.WALK:
			pass
			
		AI_STATE.JUMP:
			update()
			if target and target_pos == Vector2.ZERO:
				jump_aim(delta)
			
			if target_pos != Vector2.ZERO:
				position = position.move_toward(target_pos, delta * 150)
		
		AI_STATE.SHOOT:
			update()
			if target:
				aim()
				
				
	$HeadLabel.text = str(AI_STATE.keys()[state])

func check_att_state():
	
	
	if att_state == "idle":
		state = AI_STATE.IDLE
	elif att_state == "jump_att":
		state = AI_STATE.JUMP
	elif att_state == "shoot_att":
		state = AI_STATE.SHOOT

func idle():
	pass

func walk():
	pass
	
func jump_aim(delta:float):
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
	#for pos in [target.position]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			#print('อยู่ในเขต แต่อยู่หลังกำแพง')
			hit_pos.append(result.position)
			if result.collider.name == "Player":
				#print('เจอตัว')
				$Sprite.self_modulate.r = 1.0
				#rotation = (target.position - position).angle()
				if can_jump_att:
					target_pos = result.collider.global_position
					can_jump_att = false
				break
	

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
	#for pos in [target.position]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			#print('อยู่ในเขต แต่อยู่หลังกำแพง')
			hit_pos.append(result.position)
			if result.collider.name == "Player":
				#print('เจอตัว')
				$Sprite.self_modulate.r = 1.0
				#rotation = (target.position - position).angle()
				if can_shoot:
					shoot(pos)
				break
				
func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
	
func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body


func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		$Sprite.self_modulate.r = 0.2
		
func _on_ShootTimer_timeout():
	can_shoot = true
