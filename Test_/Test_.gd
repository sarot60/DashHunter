extends Area2D

export var gold_coin_drop:PackedScene
export var item_drop:PackedScene

func _ready():
	pass
	#for i in range(1,31):
	#	print("level ",i," = ",nextLevel(i),"xp")

func nextLevel(level):
	return round((4 * (pow(level,3))) / 5)


func _on_TestObj_body_entered(_body):
	call_deferred("drop_item")
	
	
func drop_item():
	for _i in range(5):
		var item_drop_obj = item_drop.instance()
		#drop_coin.position = Vector2(get_position().x ,get_position().y)
		item_drop_obj.global_position = Vector2(global_position.x ,global_position.y)
		#drop_coin.x_pos = x_pos[randi()%x_pos.size()]
		#drop_coin.y_pos = y_pos[randi()%y_pos.size()]
		item_drop_obj.set_x_pos_y_pos()
		get_parent().add_child(item_drop_obj)

func drop_coin():
	for _i in range(5):
		var drop_coin = gold_coin_drop.instance()
		#drop_coin.position = Vector2(get_position().x ,get_position().y)
		drop_coin.global_position = Vector2(global_position.x ,global_position.y)
		#drop_coin.x_pos = x_pos[randi()%x_pos.size()]
		#drop_coin.y_pos = y_pos[randi()%y_pos.size()]
		drop_coin.set_x_pos_y_pos()
		get_parent().add_child(drop_coin)
