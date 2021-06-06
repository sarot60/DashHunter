extends Line2D

var rng = RandomNumberGenerator.new()

var ran_eff = [
		[[-512,-512],[512,512]],
		[[-512,512],[512,-512]],
		[[512,-64],[-512,64]],
		[[512,64],[-512,-64]]
	]
	
func _ready():
	rng.randomize()
	var my_random_number = rng.randf_range(0, 2)

	points[0] = Vector2(ran_eff[round(my_random_number)][0][0],ran_eff[round(my_random_number)][0][1])
	points[1] = Vector2(ran_eff[round(my_random_number)][1][0],ran_eff[round(my_random_number)][1][1])
	
	yield(get_tree().create_timer(0.1),"timeout")
	queue_free()

