extends Control


var map_name_list:Dictionary = {
	"res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn": "GV VILLAGE",
	"res://Maps/GreenVeta/GreenVetaDungeon1/GreenVetaDungeon1.tscn": "GV DUN 1",
	"res://Maps/GreenVeta/GreenVetaDungeon2/GreenVetaDungeon2.tscn": "GV DUN 2",
	"res://Maps/GreenVeta/GreenVetaDungeon3/GreenVetaDungeon3.tscn": "GV DUN 3",
	"res://Maps/GreenVeta/GreenVetaDungeon4/GreenVetaDungeon4.tscn": "GV DUN 4",
	"res://Maps/GreenVeta/GreenVetaDungeon5/GreenVetaDungeon5.tscn": "GV DUN 5"
}


var boss_marker_color:Color = Color(0.66, 0.25, 0.25, 1)
var player_marker_color:Color = Color(0, 1.0, 0, 1)
var default_marker_color:Color = Color(0.44, 0.58, 0.4, 1.0)

var empty_marker_color:Color = Color(0, 0, 0, 0.39)

onready var map_name_label:Label = $MapName

func _ready():
	
	# Call from GreenVeta xxx.gd
	add_to_group("set_map_marker")
	
	initialize_minimap()
	
func initialize_minimap() -> void:
	var map_markers = $Map.get_children()
	for i in range(map_markers.size()):
		map_markers[i].self_modulate = empty_marker_color

# Group set_map_marker / Call from GreenVetaXXX.gd
func set_map_marker(data_list:Array) -> void:
	clear_marker()
	if data_list[0] == "GREENVETA VILLAGE":
		var map_markers = $Map.get_children()
		for i in range(map_markers.size()):
			if i == 13 - 1:
				map_markers[i].self_modulate = default_marker_color
				$PlayerMarker.global_position = map_markers[i].global_position
				return
	elif data_list[0] == "GREENVETA DUNGEON 1":
		var map_markers = $Map.get_children()
		for i in range(map_markers.size()):
			if i == 13 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 1:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 14 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 2:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 15 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 3:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 16 - 1:
				map_markers[i].self_modulate = boss_marker_color
				if data_list[1] == 4:
					$PlayerMarker.global_position = map_markers[i].global_position
	elif data_list[0] == "GREENVETA DUNGEON 2":
		var map_markers = $Map.get_children()
		for i in range(map_markers.size()):
			if i == 13 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 1:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 14 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 2:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 10 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 3:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 6 - 1:
				map_markers[i].self_modulate = boss_marker_color
				if data_list[1] == 4:
					$PlayerMarker.global_position = map_markers[i].global_position
	elif data_list[0] == "GREENVETA DUNGEON 3":
		var map_markers = $Map.get_children()
		for i in range(map_markers.size()):
			if i == 9 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 1:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 13 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 2:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 14 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 3:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 15 - 1:
				map_markers[i].self_modulate = boss_marker_color
				if data_list[1] == 4:
					$PlayerMarker.global_position = map_markers[i].global_position
	elif data_list[0] == "GREENVETA DUNGEON 4":
		var map_markers = $Map.get_children()
		for i in range(map_markers.size()):
			if i == 9 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 1:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 10 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 2:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 14 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 3:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 15 - 1:
				map_markers[i].self_modulate = boss_marker_color
				if data_list[1] == 4:
					$PlayerMarker.global_position = map_markers[i].global_position
	elif data_list[0] == "GREENVETA DUNGEON 5":
		var map_markers = $Map.get_children()
		for i in range(map_markers.size()):
			if i == 7 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 1:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 6 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 2:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 10 - 1:
				map_markers[i].self_modulate = default_marker_color
				if data_list[1] == 3:
					$PlayerMarker.global_position = map_markers[i].global_position
			elif i == 9 - 1:
				map_markers[i].self_modulate = boss_marker_color
				if data_list[1] == 4:
					$PlayerMarker.global_position = map_markers[i].global_position
		
		
func clear_marker() -> void:
	var map_markers = $Map.get_children()
	for i in range(map_markers.size()):
		map_markers[i].self_modulate = empty_marker_color
	
func set_mini_map(map_path:String) -> void:
	set_minimap_name(map_path)
	

func set_minimap_name(map_path) -> void:
	map_name_label.text = map_name_list[map_path]
