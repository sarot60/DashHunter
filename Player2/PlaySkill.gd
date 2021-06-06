extends Node2D

class_name PlaySkill

#enum {
#	NULL,
#	SKILL1,
#	SKILL2,
#	SKILL3,
#	SKILL4,
#	SKILL5,
#	SKILL6,
#	SKILL7,
#	SKILL8,
#	SKILL9,
#}
#var skill_state = NULL
	
var skill_object:Object = null

onready var player = get_parent()

var skill_name = ""
func initialize_skill(skill_slot):
	skill_name = skill_slot

func play_skill(delta, direction):
	match skill_name:
		"Skill1":
			play_skill1(delta, direction)
		"Skill2":
			play_skill2(delta, direction)
		"Skill3":
			play_skill3(delta, direction)
		"Skill4":
			play_skill4(delta, direction)
		"Skill5":
			play_skill5(delta, direction)
		"Skill6":
			play_skill6(delta, direction)
#		"Skill7":
#			play_skill7(delta, direction)
#		"Skill8":
#			play_skill8(delta, direction)
#		"Skill9":
#			play_skill9(delta, direction)
		_:
			return
			
var skill_1_move_time = 0
var super_dash_eff_explosion = preload("res://Effects/DashExplosion/DashExplosion.tscn").instance()
func play_skill1(delta, direction):
	if skill_1_move_time <= 0.05:
		player.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)
		player.get_node("SwordFacing/SwordHitbox/CollisionPolygon2D").set_deferred("disabled", false)
	skill_1_move_time += delta
	if skill_1_move_time >= 0.01:
		if skill_1_move_time <= 0.2:
			var _x = player.move_and_slide(direction.normalized() * 800, Vector2())
			# duration ระยะเวลา
			# frequency ความถี่
			# amplitude ความกว้าง
			# priority ลำดับ ตัวเลขมากทำก่อน
			# call in Player3 or Other Player
			get_tree().call_group("camera_shake", "camera_shake", [0.3, 15, 15, 1])
	if skill_1_move_time >= 0.3:
		skill_1_move_time = 0
		player.state = 0
		player.is_play_skill = false
		player.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", false)
		player.get_node("SwordFacing/SwordHitbox/CollisionPolygon2D").set_deferred("disabled", true)
		
		
func play_skill2(delta, direction):
	pass
func play_skill3(delta, direction):
	pass
func play_skill4(delta, direction):
	pass
func play_skill5(delta, direction):
	pass
func play_skill6(delta, direction):
	pass

#func play_skill7(delta, direction):
#	pass
#func play_skill8(delta, direction):
#	pass
#func play_skill9(delta, direction):
#	pass

func get_skill(slot_index):
	match slot_index:
		0:
			return game_state.state.skill_slot[slot_index]
		1:
			return game_state.state.skill_slot[slot_index]
		2:
			return game_state.state.skill_slot[slot_index]
