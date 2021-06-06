extends Node

var enemy_name:String = ""

func get_enemy_stats(enemy) -> Dictionary:
	if enemy == null: return {}
#	if enimy_level == null: return {}
	
	enemy_name = enemy
	
	match enemy_name:
#		"YELLOW_BEE":
#			return {
#				"atk": 10.0,
#				"def": 10.0,
#				"max_hp": 30.0,
#				"speed": 100.0,
#			}
		"Bat":
			return {
				"atk": 10.0,
				"def": 20.0,
				"max_hp": 120.0,
				"speed": 10.0,
			}
		"BossBee":
			return {
				"atk": 10.0,
				"def": 10.0,
				"max_hp": 200.0,
				"speed": 10.0,
			}
		"Bee":
			return {
				"atk": 10.0,
				"def": 20.0,
				"max_hp": 30.0,
				"speed": 100.0,
			}
		"Ant":
			return {
				"atk": 10.0,
				"def": 20.0,
				"max_hp": 30.0,
				"speed": 100.0,
			}
		"BabyBoxer": 
			return {
				"atk": 10.0,
				"def": 55.0,
				"max_hp": 100.0,
				"speed": 100.0,
			}
		"DarkSpider": 
			return {
				"atk": 20.0,
				"def": 30.0,
				"max_hp": 80.0,
				"speed": 10.0,
			}
		"Minotaur":
			return {
				"atk": 150.0,
				"def": 100.0,
				"max_hp": 300.0,
				"speed": 100.0,
			}
		"FlyingEye":
			return {
				"atk": 150.0,
				"def": 100.0,
				"max_hp": 300.0,
				"speed": 100.0,
			}
		"EyeBall":
			return {
				"atk": 50.0,
				"def": 5.0,
				"max_hp": 200.0,
				"speed": 100.0,
			}
		"SkeletonMage":
			return {
				"atk": 50.0,
				"def": 10.0,
				"max_hp": 100.0,
				"speed": 100.0,
			}
		"FireMageGolem":
			return {
				"atk": 30.0,
				"def": 20.0,
				"max_hp": 100.0,
				"speed": 100.0,
			}
		"FireWorm":
			return {
				"atk": 50.0,
				"def": 100.0,
				"max_hp": 500.0,
				"speed": 100.0,
			}
		"SneakyToast":
			return {
				"atk": 20.0,
				"def": 10.0,
				"max_hp": 50.0,
				"speed": 100.0,
			}
		"MechaStoneGolem":
			return {
				"atk": 100.0,
				"def": 200.0,
				"max_hp": 1000.0,
				"speed": 100.0,
			}
		
	return {}
