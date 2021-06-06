extends StaticBody2D

export(Texture) var sword_max
export(Texture) var sword_half
export(Texture) var sword_min

var health = 3

onready var hit_effect = preload("res://Effects/HitEffect/HitEffect.tscn")
onready var death_effect = preload("res://Effects/DeathEffect/DeathEffect.tscn")

func _ready():
	
	#$HealthBar.value = health
	$please_att_icon.texture = sword_max
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")

func death():
	
	#get_tree().call_group("ant_destroy", "update_mission", "the_ant_nest_has_been_destroyed")
	get_tree().call_group("bee_nest_destroy", "bee_nest_destroy", "the_boss_bee_has_been_destroyed")
	
	var death_effect_obj = death_effect.instance()
	death_effect_obj.global_position = position
	get_parent().add_child(death_effect_obj)
	
	queue_free()
	
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# call in Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [0.4, 15, 10, 0])
	
# -------------- Signal ---------------------
func _on_Hurtbox_area_entered(_area):
	health -= 1
	
	var hit_eff_obj = hit_effect.instance()
	hit_eff_obj.global_position = position - Vector2(0,8)
	get_parent().add_child(hit_eff_obj)
	
	#$HealthBar.value = health
	if health == 2:
		$please_att_icon.texture = sword_half
	elif health == 1:
		$please_att_icon.texture = sword_min
	
	if health <= 0:
		death()
