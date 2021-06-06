extends AudioStreamPlayer2D

var rng = RandomNumberGenerator.new()

func _ready():
	play(0)

func _on_crow_sfx_finished():
	rng.randomize()
	var my_random_number = rng.randf_range(3, 10)

	yield(get_tree().create_timer(my_random_number),"timeout")
	play(0)
