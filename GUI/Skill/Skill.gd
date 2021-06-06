extends Control

var skill_1_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons1.png")
var skill_2_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons2.png")
var skill_3_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons3.png")
var skill_4_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons7.png")
var skill_5_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons8.png")
var skill_6_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons13.png")
#var skill_7_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons14.png")
#var skill_8_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons19.png")
#var skill_9_img = preload("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons20.png")

var skill_empty_img = preload("res://Assets/Skill/skill-empty-rectangle-24x24.png")

var bg_no_outline_img = preload("res://Assets/Skill/bg_no_outline.png")
var bg_outline_img = preload("res://Assets/Skill/bg_outline.png")

onready var skill = $TextureRect/Skill
onready var skill_slot = $TextureRect/SkillSlot

var prev_focus
var cur_focus

var level_unlock = {
	0: 3,
	1: 6,
	2: 9,
	3: 12,
	4: 15,
	5: 20
}

func _ready():
	hide()
	
	var player_level = game_state.state.level
	
	var all_skill = skill.get_children()
	for i in range(all_skill.size()):
		all_skill[i].modulate = Color(1, 1, 1, 0.3)
		
		all_skill[i].connect("gui_input", self, "skill_gui_input", [all_skill[i]])
		
		if i == 6:
			break
		
		if player_level >= level_unlock[i]:
			all_skill[i].modulate = Color(1, 1, 1, 1)
		
	var skill_slots = skill_slot.get_children()
	for i in range(skill_slots.size()):
		skill_slots[i].get_node("ChangeButton").connect("pressed", self, "skill_change_pressed", [skill_slots[i].get_node("ChangeButton")])
		skill_slots[i].get_node("ChangeButton").hide()
		
	initialize_skill_slot()
	initialize_skill()

func initialize_skill_slot():
	var skill_slots = skill_slot.get_children()
	
	for i in range(skill_slots.size()):
		skill_slots[i].get_node("ChangeButton").hide()
		
	for i in range(skill_slots.size()):
		if game_state.state.skill_slot[i] != null:
			var has_skill_style = StyleBoxTexture.new()
			has_skill_style.texture = select_skill(int(game_state.state.skill_slot[i].split("Skill")[1]) - 1)
			skill_slots[i].set('custom_styles/panel', has_skill_style)
		else:
			var empty_style = StyleBoxTexture.new()
			empty_style.texture = skill_empty_img
			skill_slots[i].set('custom_styles/panel', empty_style)
	
func initialize_skill():
	
	var player_level = game_state.state.level
	
	var all_skill = skill.get_children()
	for i in range(all_skill.size()):
		var empty_style = StyleBoxTexture.new()
		var img_sk = select_skill(i)
		empty_style.texture = bg_no_outline_img
		all_skill[i].set('custom_styles/panel', empty_style)
		
		all_skill[i].get_node("Sprite").texture = img_sk

	for i in range(all_skill.size()):
		all_skill[i].modulate = Color(1, 1, 1, 0.3)
		
		if i == 6:
			break
		
		if player_level >= level_unlock[i]:
			all_skill[i].modulate = Color(1, 1, 1, 1)
	
	cur_focus = null
	prev_focus = null
	
func select_skill(index):
	match index:
		0:
			return skill_1_img
		1:
			return skill_2_img
		2:
			return skill_3_img
		3:
			return skill_4_img
		4:
			return skill_5_img
		5:
			return skill_6_img
#		6:
#			return skill_7_img
#		7:
#			return skill_8_img
#		8:
#			return skill_9_img
		_:
			return skill_empty_img

func skill_gui_input(event: InputEvent, slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			
			if game_state.state.level < level_unlock[int(slot.name.split("Skill")[1]) - 1]:
				return
				#print(int(slot.name.split("Skill")[1]) - 1)
			
			switch_focus(slot)
			
			var skill_slots = skill_slot.get_children()
			for i in range(skill_slots.size()):
				if slot.name == game_state.state.skill_slot[i]:
					for j in range(skill_slots.size()):
						skill_slots[j].get_node("ChangeButton").hide()
					return
				skill_slots[i].get_node("ChangeButton").show()
			
func skill_change_pressed(slot):
	
	var skill_slots = skill_slot.get_children()
	for i in range(skill_slots.size()):
		skill_slots[i].get_node("ChangeButton").hide()
		
	#print(cur_focus.name)
	
	#print(slot.get_parent().name)

	var focus_style = StyleBoxTexture.new()
	focus_style.texture = select_skill(int(cur_focus.name.split("Skill")[1])-1)
	slot.get_parent().set('custom_styles/panel', focus_style)

	var cur_focus_skill_name = cur_focus.name
	var put_to_slot = int(slot.get_parent().name.split("Slot")[1]) - 1
	
	game_state.state.skill_slot[put_to_slot] = cur_focus_skill_name
	
	clear_focus(cur_focus)
	clear_focus(prev_focus)
	
	cur_focus = null
	prev_focus = null
	
	get_tree().call_group("skill_change", "update_skill_slot", self)
	
func switch_focus(slot):
	cur_focus = slot
	
	if cur_focus == prev_focus:
		return
	
	if prev_focus: 
		clear_focus(prev_focus)
	
	var outline_panel_style = StyleBoxTexture.new()
	outline_panel_style.texture = bg_outline_img
	slot.set('custom_styles/panel', outline_panel_style)
	
	prev_focus = cur_focus

func clear_focus(slot):
	var not_outline_panel_style = StyleBoxTexture.new()
	not_outline_panel_style.texture = bg_no_outline_img
	slot.set('custom_styles/panel', not_outline_panel_style)
	

func _on_CloseSkillPopup_pressed():
	get_tree().call_group("update_inv", "update_inv_status", false)
	hide()
