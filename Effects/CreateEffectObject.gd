extends Node2D

var rng = RandomNumberGenerator.new()


onready var hit_effect = preload("res://Effects/HitEffect/HitEffect.tscn")
func create_hit_effect(pos:Vector2 = Vector2(0,0)):
	# hit effect
	var hit_eff_obj = hit_effect.instance()
	hit_eff_obj.global_position = get_parent().position + pos
	get_parent().get_parent().add_child(hit_eff_obj)

#onready var hit_effect2 = preload("res://Effects/HitEffect2/HitEffect2.tscn")
func create_hit_effect2(pos:Vector2 = Vector2(0,0)):
	# hit effect
	var hit_effect2 = load("res://Effects/HitEffect2/HitEffect2.tscn")
	var hit_eff2_obj = hit_effect2.instance()
	hit_eff2_obj.global_position = get_parent().position + pos
	get_parent().get_parent().add_child(hit_eff2_obj)
	#get_tree().current_scene.add_child(hit_eff2_obj)
	
onready var hit_effect3 = preload("res://Effects/HitEffect3/HitEffect3.tscn")
func create_hit_effect3(pos:Vector2 = Vector2(0,0)):
	# hit effect
	var hit_eff3_obj = hit_effect3.instance()
	hit_eff3_obj.global_position = get_parent().position + pos
	hit_eff3_obj.rotation = global_position.angle_to_point(Game.player.global_position)
	get_parent().get_parent().add_child(hit_eff3_obj)
	#get_tree().current_scene.add_child(hit_eff2_obj)
	
onready var blood1 = preload("res://Effects/BloodEffect1/BloodEffect1.tscn")
func create_blood_effect():
	var blood_instance = blood1.instance()
	blood_instance.global_position = get_parent().position
	blood_instance.rotation = global_position.angle_to_point(Game.player.global_position)
	#get_tree().current_scene.add_child(blood_instance)
	get_parent().get_parent().add_child(blood_instance)

onready var floating_text = preload("res://Effects/FloatingText/FloatingText.tscn")
func create_floating_text(amount:int = 0):
	var ft = floating_text.instance()
	ft.global_position = Vector2(global_position)
	ft.velocity = Vector2(rand_range(-50, 50), -100)
	#ft.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	### White
	ft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	#var amount = randi()%10 - 5
	
	ft.text = amount
	
	#if amount > 0:
	#	ft.text = "-" + ft.text
		
#	get_parent().add_child(ft)
#	get_parent().get_parent().add_child(ft)
	get_tree().current_scene.add_child(ft)
	
onready var critical_floating_text = preload("res://Effects/CriticalFloatingText/CriticalFloatingText.tscn")
func create_critical_floating_text(amount:int = 0):
	var cri_ft = critical_floating_text.instance()
	cri_ft.global_position = Vector2(global_position)
	cri_ft.velocity = Vector2(rand_range(-50, 50), -100)
	#ft.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	### White
	cri_ft.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	#var amount = randi()%10 - 5
	
	cri_ft.text = amount
	
	#if amount > 0:
	#	ft.text = "-" + ft.text
		
#	get_parent().add_child(ft)
#	get_parent().get_parent().add_child(ft)
	get_tree().current_scene.add_child(cri_ft)


onready var attack_line_effect = preload("res://Effects/AttackLineEffect/AttackLine.tscn")
func create_attack_line_effect(pos:Vector2 = Vector2(0,0)):
	var eff = attack_line_effect.instance()
	eff.global_position = global_position + pos
	get_parent().get_parent().add_child(eff)

	var eff2 = attack_line_effect.instance()
	eff2.global_position = global_position + pos
	eff2.width = 1
	get_parent().get_parent().add_child(eff2)
	

onready var death_effect = preload("res://Effects/DeathEffect/DeathEffect.tscn")
func create_death_effect():
	var death_effect_obj = death_effect.instance()
	death_effect_obj.global_position = global_position
#	get_parent().add_child(death_effect_obj)
	#get_parent().get_parent().add_child(death_effect_obj)
	get_tree().current_scene.add_child(death_effect_obj)
	
	
onready var gold_coin_drop = preload("res://GUI/Inventory/Coin/CoinDrop.tscn")
func create_drop_coin(coin_count_range:Array = [0,0], pos:Array = [0,0]):
	if coin_count_range == [0,0]: return
	if coin_count_range[0] > coin_count_range[1]: return
	
	rng.randomize()
	var rand = round(rng.randf_range(coin_count_range[0],coin_count_range[1]))

	#var rand = round(rand_range(coin_count_range[0], coin_count_range[1]))
	for _i in range(rand):
		var drop_coin = gold_coin_drop.instance()
		#drop_coin.position = Vector2(get_position().x ,get_position().y)
		#drop_coin.global_position = Vector2(global_position.x ,global_position.y)
		drop_coin.global_position = get_parent().position + Vector2(pos[0],pos[1])
		#drop_coin.x_pos = x_pos[randi()%x_pos.size()]
		#drop_coin.y_pos = y_pos[randi()%y_pos.size()]
		drop_coin.set_x_pos_y_pos()
		#get_parent().add_child(drop_coin)
		get_parent().get_parent().call_deferred("add_child", drop_coin)
		

#onready var item_drop = preload("res://GUI/Inventory/ItemDrop.tscn")
func create_item_drop(item_id_list:Array):
	if item_id_list.size() == 0: return
	var item_drop_class = load("res://GUI/Inventory/ItemDrop.tscn")
	for i in range(item_id_list.size()):
		var item_drop_obj = item_drop_class.instance()
		item_drop_obj.initialize_item_drop(item_id_list[i])
		item_drop_obj.global_position = get_parent().position
		item_drop_obj.set_x_pos_y_pos()
		get_parent().get_parent().call_deferred("add_child", item_drop_obj)


#onready var pick_item_effect = preload("res://Effects/PickItemEffect/PickItemEffect.tscn")
#func create_pick_item_effect():
#	var pick_item_effect_obj = pick_item_effect.instance()
#	pick_item_effect_obj.global_position = global_position
##	get_parent().add_child(death_effect_obj)
#	#get_parent().get_parent().add_child(death_effect_obj)
#	get_tree().current_scene.add_child(pick_item_effect_obj)


onready var heal_effect = preload("res://Effects/HealEffect/HealEffect.tscn")
func create_heal_effect(pos:Vector2 = Vector2(0,0)):
	var heal_effect_obj = heal_effect.instance()
	heal_effect_obj.position = position + pos
	get_parent().add_child(heal_effect_obj)
	
