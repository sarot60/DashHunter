extends Node2D


var map_name = "GREENVETA VILLAGE"

var hud_minimap:Control 

func _ready():
	if Game.main != null:
		
		hud_minimap = Game.main.get_node("HUD/MiniMap")
		set_minimap_marker(map_name, 1)
		
		yield(get_tree().create_timer(0.5),"timeout")
		Game.main.get_node("GameAlert/ChangeMapAlert/MapName").text = "GREENVETA VILLAGE"
		Game.main.get_node("GameAlert/ChangeMapAlert/AnimationPlayer").play("play")
	
	
func set_minimap_marker(cur_map, cur_stage):
	if Game.main == null: return
	if hud_minimap == null: return
	
	var data_list:Array = [cur_map, cur_stage]
	
	hud_minimap.set_map_marker(data_list)
