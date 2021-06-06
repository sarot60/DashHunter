extends Node2D

var current_stage = 1
var max_stage = 4

var player_life = 3

var stage_get_key_mission = {
	1: 3,
	2: 3,
	3: 3,
	4: null
}

onready var gate1 = $YSort/Stage1/BarrierGate/Gate
onready var gate2 = $YSort/Stage2/BarrierGate/Gate
onready var gate3 = $YSort/Stage3/BarrierGate/Gate

onready var dungeon_hud = $DungeonHUD

var pos_on_map = {
	"stage_1_start_pos": Vector2(0,0),
	"stage_2_start_pos": Vector2(1900,160),
	"stage_3_start_pos": Vector2(2276,-1404),
	"stage_4_start_pos": Vector2(2228,-3436),
	"back_to_stage_1_pos": Vector2(720,150),
	"back_to_stage_2_pos": Vector2(2296,-34),
	"back_to_stage_3_pos": Vector2(2288,-1840)
}

var boss = null

onready var gate_list = $GateDetection.get_children()

var map_name = "GREENVETA DUNGEON 2"


func _ready():
	# call from Player.gd
	add_to_group("player_died")
	
	# call from WoodTreasure.gd
	add_to_group("get_key")
	
	# call from Fireworm or Bos etc ...
	add_to_group("need_boss_ref")
	
	
	# call to MiniMap.gd
	get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 1])
	
	
	for i in range(gate_list.size()):
		gate_list[i].get_node("Area2D").connect("body_entered", self,"_on_Gatebox_body_entered", [gate_list[i]])
	
	if Game.main != null:
		Game.main.get_node("GameAlert/ChangeMapAlert/MapName").text = map_name
		Game.main.get_node("GameAlert/ChangeMapAlert/AnimationPlayer").play("play")
		
		
	if $YSort/Stage4/Boss.get_children().size() > 0:
		boss = $YSort/Stage4/Boss.get_child(0)

	
	Game.player.global_position = pos_on_map["stage_1_start_pos"]
	dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 1"
	yield(get_tree().create_timer(1),"timeout")
	
	dungeon_hud.start()
	
	yield(get_tree().create_timer(1),"timeout")
	$DungeonHUD.set_stage_alert("STAGE 1")


func set_stage_boss():
	if boss == null: return
	
	dungeon_hud.get_node("BossBarFrame/BossHealthBar").max_value = boss.max_health
	dungeon_hud.get_node("BossBarFrame/BossHealthBar").value = boss.health

""" ========================================== Group ========================================"""

var key_count = 0
# Group get_key / call from WoodTreasure.gd
func update_key(_param):
	if stage_get_key_mission[current_stage] == null: return
	key_count += 1
	if key_count < stage_get_key_mission[current_stage]:
		$DungeonHUD.update_key(key_count)
		return
	if key_count == stage_get_key_mission[current_stage]:
		$DungeonHUD.update_key(key_count)
		key_count = 0
		yield(get_tree().create_timer(2),"timeout")
		$DungeonHUD.update_key(key_count)
		if current_stage == 1:
			$DungeonHUD.get_node("GateOpenSound").play()
			for i in gate1.get_children():
				if i.has_method("bomb"):
					i.bomb()
		elif current_stage == 2:
			$DungeonHUD.get_node("GateOpenSound").play()
			for i in gate2.get_children():
				if i.has_method("bomb"):
					i.bomb()
		elif current_stage == 3:
			$DungeonHUD.get_node("GateOpenSound").play()
			for i in gate3.get_children():
				if i.has_method("bomb"):
					i.bomb()
			set_stage_boss()
		if Game.main != null:
			Game.main.get_node("GameAlert/ChangeMapAlert/MapName").text = "GATE OPEN"
			Game.main.get_node("GameAlert/ChangeMapAlert/AnimationPlayer").play("play")
		current_stage += 1
		return

# Group need_boss_ref / Call from all Boss .gd
func set_boss_hp(cur_hp):
	if boss == null: return
	dungeon_hud.get_node("BossBarFrame/BossHealthBar").value = boss.health

# Group need_boss_ref / Call from all Boss .gd
func boss_death(_param):
	if boss == null: return
	dungeon_hud.time_stop = true
	
	dungeon_hud.end_dungeon = true
	
	dungeon_hud.get_node("exit_hint").show()

# Group player_died / Call from Player.gd
func player_died(_param):
	player_life -= 1
	dungeon_hud.set_life_icon(player_life)
	
	# call to MiniMap.gd
	get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 1])
	
	if player_life == 0:
		if Game.main == null: return
	
		Game.main.curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
		Game.main.LoadGameState()
		
""" ============================================ End Group ========================================"""

func _on_Gatebox_body_entered(_body, gate_data):
	if gate_data.gate_name == "": return
	#if Game.main == null: return
	
	if gate_data.gate_name == "goto_stage_2":
		if Game.main != null:
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_in")
			yield(get_tree().create_timer(0.2),"timeout")
		Game.player.global_position = pos_on_map["stage_2_start_pos"]
		dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 2"
		if Game.main != null:
			yield(get_tree().create_timer(0.5),"timeout")
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_out")
			
		yield(get_tree().create_timer(0.1),"timeout")
		$DungeonHUD.set_stage_alert("STAGE 2")
		
		# call to MiniMap.gd
		get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 2])
			
	elif gate_data.gate_name == "backto_stage_1":
		if Game.main != null:
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_in")
			yield(get_tree().create_timer(0.2),"timeout")
		Game.player.global_position = pos_on_map["back_to_stage_1_pos"]
		dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 1"
		if Game.main != null:
			yield(get_tree().create_timer(0.5),"timeout")
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_out")
			
		yield(get_tree().create_timer(0.1),"timeout")
		$DungeonHUD.set_stage_alert("STAGE 1")
		
		# call to MiniMap.gd
		get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 1])
		
			
	elif gate_data.gate_name == "goto_stage_3":
		if Game.main != null:
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_in")
			yield(get_tree().create_timer(0.2),"timeout")
		Game.player.global_position = pos_on_map["stage_3_start_pos"]
		dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 3"
		if Game.main != null:
			yield(get_tree().create_timer(0.5),"timeout")
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_out")
			
		yield(get_tree().create_timer(0.1),"timeout")
		$DungeonHUD.set_stage_alert("STAGE 3")
		
		# call to MiniMap.gd
		get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 3])
			
	elif gate_data.gate_name == "backto_stage_2":
		if Game.main != null:
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_in")
			yield(get_tree().create_timer(0.2),"timeout")
		Game.player.global_position = pos_on_map["back_to_stage_2_pos"]
		dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 2"
		if Game.main != null:
			yield(get_tree().create_timer(0.5),"timeout")
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_out")
			
		yield(get_tree().create_timer(0.1),"timeout")
		$DungeonHUD.set_stage_alert("STAGE 2")
		
		# call to MiniMap.gd
		get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 2])
			
	elif gate_data.gate_name == "goto_stage_4":
		if Game.main != null:
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_in")
			yield(get_tree().create_timer(0.2),"timeout")
		Game.player.global_position = pos_on_map["stage_4_start_pos"]
		dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 4"
		if Game.main != null:
			yield(get_tree().create_timer(0.5),"timeout")
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_out")
			
		yield(get_tree().create_timer(0.1),"timeout")
		$DungeonHUD.set_stage_alert("STAGE 4")
		$DungeonHUD/BossBarFrame.show()
		
		# call to MiniMap.gd
		get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 4])
			
	elif gate_data.gate_name == "backto_stage_3":
		if Game.main != null:
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_in")
			yield(get_tree().create_timer(0.2),"timeout")
		Game.player.global_position = pos_on_map["back_to_stage_3_pos"]
		dungeon_hud.get_node("DungeonStateBg/StageNumber").text = "STAGE 3"
		if Game.main != null:
			yield(get_tree().create_timer(0.5),"timeout")
			Game.main.get_node("MapFade/AnimationPlayer").play("fade_out")
		
		yield(get_tree().create_timer(0.1),"timeout")
		$DungeonHUD.set_stage_alert("STAGE 3")
		
		# call to MiniMap.gd
		get_tree().call_group("set_map_marker", "set_map_marker", [map_name, 3])
		
