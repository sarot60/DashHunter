extends Control


onready var anim_player = $AnimationPlayer

var text_stack = []

func _ready():
	hide()
	
	# call from NPC_Dialog.gd
	add_to_group("add_data_to_play")
	
func add_data_to_play(message:String):
	text_stack.append(message)
	
	if text_stack.size() > 1:
		if text_stack[text_stack.size() - 1] == message:
			text_stack.pop_back()
			
	if !anim_player.is_playing():
		set_text_to_play_anim()
		
	
func set_text_to_play_anim():
	show()
	$Label.text = text_stack[0]
	text_stack.pop_front()
	play_anim("play")

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func _on_AnimationPlayer_animation_finished(_anim_name):
	if text_stack.size() > 0:
		set_text_to_play_anim()
	else:
		hide()
		
