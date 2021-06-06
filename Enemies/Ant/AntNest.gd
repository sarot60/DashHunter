extends StaticBody2D


export(Texture) var sword_max
export(Texture) var sword_half
export(Texture) var sword_min


var health = 3

onready var create_effect_object = $CreateEffectObject

onready var anim_player = $AnimationPlayer



func _ready():
	
	#$HealthBar.value = health
	$please_att_icon.texture = sword_max
	
	if has_node("Hurtbox"):
		var _Con1 = get_node("Hurtbox").connect("area_entered", self, "_on_Hurtbox_area_entered")
		
		
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func death():
	
	get_tree().call_group("ant_destroy", "update_mission", "the_ant_nest_has_been_destroyed")
	
	create_effect_object.create_death_effect()
	
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
	
	create_effect_object.create_floating_text(1)
	
#	create_effect_object.create_hit_effect()
	create_effect_object.create_hit_effect2()
	
	play_anim("shake")

	#$HealthBar.value = health
	if health == 2:
		$please_att_icon.texture = sword_half
	elif health == 1:
		$please_att_icon.texture = sword_min
	
	if health <= 0:
		death()


