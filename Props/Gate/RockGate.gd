extends StaticBody2D

onready var death_effect = preload("res://Effects/DeathEffect/DeathEffect.tscn")

func bomb():
	
	var death_effect_obj = death_effect.instance()
	death_effect_obj.global_position = global_position
	#get_parent().add_child(death_effect_obj)
	get_tree().current_scene.add_child(death_effect_obj)
	
	# duration ระยะเวลา
	# frequency ความถี่
	# amplitude ความกว้าง
	# priority ลำดับ ตัวเลขมากทำก่อน
	# Call to Player3 or Other Player
	get_tree().call_group("camera_shake", "camera_shake", [1, 15, 15, 99])
	
	queue_free()
