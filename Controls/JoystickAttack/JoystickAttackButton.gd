extends TouchScreenButton

var radius = Vector2(24, 24)
var boundary = 32

var ongoing_drag = -1

var return_accel = 20

var threshold = 10

var type = "JoystickAttack"

onready var attack_cursor = get_parent().get_parent().get_parent().get_parent().get_node("CursorAttack/AttackCursor")

# variable for attack cursor
var set_cursor = Vector2()
#var default_ark_cur = Vector2(64, -8)
var default_ark_cur = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0, 0) - radius) - position
		position += pos_difference * return_accel * delta
		
		# working for attack cursor
		var atk_cur_pos_difference = (default_ark_cur - Vector2(48, 48)) - attack_cursor.position
		attack_cursor.position += atk_cur_pos_difference * return_accel * delta
		attack_cursor.visible = false

func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
#	if (event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed())) and is_pressed():
		var event_dist_from_centre = (event.position - get_parent().global_position).length()
		
		if event_dist_from_centre <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
			
			if get_button_pos().length() > boundary:
				set_position( get_button_pos().normalized() * boundary - radius)
				
			# for cursor attack
			if get_button_pos().length() > threshold + 5:
				attack_cursor.visible = true
				attack_cursor.set_position(get_button_pos().normalized() * 64 - Vector2(48, 48))
			else:
				ongoing_drag = -1
				attack_cursor.visible = false
			#set_cursor = get_button_pos().normalized() * boundary - radius
				
			ongoing_drag = event.get_index()
			
		
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		

func get_cursor_atk_value():
	if get_button_pos().length() > threshold+5:
		return (attack_cursor.position + Vector2(48, 48)).normalized()
	return Vector2(0, 0)
	
func get_value():
	if get_button_pos().length() > threshold+5:
		return get_button_pos().normalized()
	return Vector2(0, 0)
