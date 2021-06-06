extends RigidBody2D

# gdscrip module
var rng = RandomNumberGenerator.new()

var item_name:String
var player:Object = null
var being_picked_up = false

var motion = Vector2()
var x_pos = -50
var y_pos = -150
var is_on_ground = false

var rand_timer:float = 0
var time_to_fall:float = 0

var rand_x_pos = [-50,-45,-40,-35,-30,-25,-20,20,25,30,35,40,45,50]
var rand_y_pos = [-150,-140,-130,-120,-110,-100]

const MAGNET_SMOOTH_SPEED = 8
var position_difference = Vector2()
var smoothed_velocity = Vector2()

onready var pick_item_effect = preload("res://Effects/PickItemEffect/PickItemEffect.tscn")

func _ready():
	#item_name = "Iron Sword"
	
	rng.randomize()
	#rand_timer = round(rng.randf_range(0.5,1))
	rand_timer = rng.randf_range(0.7,1)

	_random_drop()
	
func _process(delta):
	time_to_fall += delta
	if time_to_fall >= rand_timer:
		time_to_fall = 0
		#set_process(false)
		
		gravity_scale = 0
		mode = RigidBody2D.MODE_STATIC
		
		$Sprite/Shadow.show()
		$DropHurtbox/CollisionShape2D.set_deferred("disabled", false)
		$Magnet/CollisionShape2D.set_deferred("disabled", false)
		
	if player != null:

		#var destination = get_global_mouse_position()
		var destination = player.global_position

		position_difference = destination - global_position
		smoothed_velocity = position_difference * MAGNET_SMOOTH_SPEED * delta

		global_position += smoothed_velocity
		
func initialize_item_drop(item_id:String):
	item_name = item_id
	$Sprite.texture = load("res://Assets/item_icons/"+ item_id +".png")

func _random_drop():
	set_axis_velocity(Vector2(x_pos,y_pos))

func set_x_pos_y_pos():
	x_pos = rand_x_pos[randi()%rand_x_pos.size()]
	y_pos = rand_y_pos[randi()%rand_y_pos.size()]


func create_pick_item_effect():
	var pick_item_effect_obj = pick_item_effect.instance()
	pick_item_effect_obj.global_position = global_position
#	get_parent().add_child(death_effect_obj)
	#get_parent().get_parent().add_child(death_effect_obj)
	get_tree().current_scene.add_child(pick_item_effect_obj)


#func pick_up_item(body):
#	player = body
#	#being_picked_up = true
#	PlayerInventory.add_item(item_name, 1)
#	create_pick_item_effect()
#	queue_free()


func _on_Magnet_body_entered(body):
	if player != null: return
	player = body


func _on_DropHurtbox_body_entered(_body):
	create_pick_item_effect()
	if item_name != "":
		PlayerInventory.add_item(item_name, 1, 0)

#	AddExperience.add_coin(10)
	queue_free()
