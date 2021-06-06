extends Node

const GAMESTATE_FILE = "gamedata.dat"

var player = null setget _set_player, _get_player

# warning-ignore:unused_class_variable
var main = null

# warning-ignore:unused_class_variable
var debug = false

func _ready():
	self.pause_mode = PAUSE_MODE_PROCESS
	print('game')

#-------------------- set player -----------------
func _set_player(v):
	player = weakref(v)
func _get_player():
	if player == null: return null
	return player.get_ref()
#-------------------------------------------------


