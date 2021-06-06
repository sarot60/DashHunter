extends StaticBody2D

onready var anim_player = $AnimationPlayer

onready var create_effect_object = $CreateEffectObject

var open = false

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func _on_Hurtbox_area_entered(_area):
	if !open:
		play_anim("open")
		open = true
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "open":
		create_effect_object.create_drop_coin([5, 10],[0, -16])
		
		$DropSound.play()
		
		# call to GreenVeta XXX.gd
		get_tree().call_group("get_key", "update_key", self)
		$KeyDrop/AnimationPlayer.play("play")
