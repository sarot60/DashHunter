extends Control

var skill_empty_slot = preload("res://Assets/Skill/skill-empty-rectangle-24x24.png")

onready var skill_slot = $SkillSlot 

func _ready():
	var skill_slots = skill_slot.get_children()
	for i in range(skill_slots.size()):
		skill_slots[i].set_normal_texture(skill_empty_slot)
		
	initialize_skill_slot()
	
func initialize_skill_slot():

	var skill_slots = skill_slot.get_children()
	for i in range(skill_slots.size()):
		if game_state.state.skill_slot[i] != null:
			skill_slots[i].set_normal_texture(select_skill(int(game_state.state.skill_slot[i].split("Skill")[1]) - 1))
		else:
			skill_slots[i].set_normal_texture(skill_empty_slot)

func select_skill(index):
	match index:
		0:
			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons1.png")
		1:
			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons2.png")
		2:
			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons3.png")
		3:
			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons7.png")
		4:
			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons8.png")
		5:
			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons13.png")
#		6:
#			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons14.png")
#		7:
#			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons19.png")
#		8:
#			return load("res://Assets/Skill/skill_icons_by_quintino_pixels/24x24/skill_icons20.png")
		_:
			return skill_empty_slot
