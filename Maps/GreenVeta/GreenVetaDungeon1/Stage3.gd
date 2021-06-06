extends YSort


var bee_nest = preload("res://Enemies/Bee/BeeNest.tscn")

func _ready():
	add_to_group("boss_bee_take_fly")


func boss_bee_take_fly(_param):
	if get_node("BeeNest").get_child_count() > 0:
		for i in get_node("BeeNest").get_children():
			i.queue_free()
	
	for i in range(0,3):
		if i == 0:
			var bee_nest_obj = bee_nest.instance()
			bee_nest_obj.position = Vector2(6, -116)
			get_node("BeeNest").add_child(bee_nest_obj)
		elif i == 1:
			var bee_nest_obj = bee_nest.instance()
			bee_nest_obj.position = Vector2(-100, 100)
			get_node("BeeNest").add_child(bee_nest_obj)
		elif i == 2:
			var bee_nest_obj = bee_nest.instance()
			bee_nest_obj.position = Vector2(80, 80)
			get_node("BeeNest").add_child(bee_nest_obj)
