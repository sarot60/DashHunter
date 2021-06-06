extends CanvasLayer

var time_stop = true

var mms = 0

var ms = 0
var s = 0
var m = 0
var h = 0

var end_dungeon = false

onready var health_1 = $DungeonStateBg/LifeIcon/health_1
onready var health_2 = $DungeonStateBg/LifeIcon/health_2
onready var health_3 = $DungeonStateBg/LifeIcon/health_3

var dungeon_time = ""

#picture
onready var full_health_icon = preload("res://Assets/Theme2/HealthIcon.png")
onready var empty_health_icon = preload("res://Assets/Theme2/HealthIconEmpty.png")

var key_icon = preload("res://Assets/HUD_And_GUI/gold-key.png")
var key_icon_empty = preload("res://Assets/HUD_And_GUI/gold-key-empty.png")

func _ready():
	health_1.texture = full_health_icon
	health_2.texture = full_health_icon
	health_3.texture = full_health_icon
	
	$ConfirmDialog/ColorBg.hide()
	$EndStageAlert/EndStage.hide()
	
	var _tmp1 = $ConfirmDialog/ColorBg/ConfirmBg/YesButton.connect("pressed", self, "_on_YesButton_pressed")
	var _tmp2 = $ConfirmDialog/ColorBg/ConfirmBg/NoButton.connect("pressed", self, "_on_NoButton_pressed")
	
	var _tmp3 = $EndStageAlert/EndStage/TextureRect/ExitButtonEndGame.connect("pressed", self, "_on_ExitButtonEndGame_pressed")
	var _tmp4 = $EndStageAlert/EndStage/TextureRect/CloseButton.connect("pressed", self, "_on_CloseButton_pressed")
	
	update_key(0)
	
func _process(_delta):
	if !time_stop:
		stop_watch()
		
func start():
	time_stop = false
	$Clock.start()
	$MSTimer.start()

func set_life_icon(life_count:int):
	if life_count > 3: return
	if life_count < 0: return
	
	if life_count == 0:
		health_1.texture = empty_health_icon
		health_2.texture = empty_health_icon
		health_3.texture = empty_health_icon
	elif life_count == 1:
		health_1.texture = full_health_icon
		health_2.texture = empty_health_icon
		health_3.texture = empty_health_icon
	elif life_count == 2:
		health_1.texture = full_health_icon
		health_2.texture = full_health_icon
		health_3.texture = empty_health_icon

func stop_watch():
	#	if ms > 9:
	#		s += 1
	#		ms = 0
	#
	#	if s > 59:
	#		m += 1
	#		s = 0

		if ms >= 9:
			s += 1
			ms = 0
		
		if s >= 60:
			m += 1
			s = 0
		
		if m >= 60:
			h += 1
			m = 0
		
		var time_text = ""
		
		if str(h).length() < 2:
			time_text = time_text +  "0" + str(h) + ":"
		else:
			time_text = time_text + str(h) + ":"
		
		if str(m).length() < 2:
			time_text = time_text +  "0" + str(m) + ":"
		else:
			time_text = time_text + str(m) + ":"
			
		if str(s).length() < 2:
			time_text = time_text + "0" + str(s) + ":"
		else:
			time_text = time_text + str(s) + ":"

		time_text = time_text + str(ms) + str(mms)
		dungeon_time = time_text
		
		$DungeonStateBg/StopWatch.text = time_text
		
func _on_YesButton_pressed():
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
	Game.main.LoadGameState()
	
func _on_NoButton_pressed():
	$ConfirmDialog/ColorBg.hide()
	
func set_stage_alert(stage:String):
	if $StageAlert/AnimationPlayer.is_playing():
		$StageAlert/AnimationPlayer.stop(true)
	$StageAlert/StageNumber.text = stage
	$StageAlert/AnimationPlayer.play("alert")
	
func update_key(key_count:int):
	var keys = $GateItemRequire.get_children()
	for i in range(keys.size()):
		keys[i].texture = key_icon_empty
	match key_count:
		0:
			var all_key = $GateItemRequire.get_children()
			for i in range(all_key.size()):
				all_key[i].texture = key_icon_empty
		1:
			var all_key = $GateItemRequire.get_children()
			for i in range(1):
				all_key[i].texture = key_icon
		2:
			var all_key = $GateItemRequire.get_children()
			for i in range(2):
				all_key[i].texture = key_icon
		3:
			var all_key = $GateItemRequire.get_children()
			for i in range(all_key.size()):
				all_key[i].texture = key_icon

func _on_ExitButtonEndGame_pressed():
	if Game.main == null: return
	
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
	Game.main.LoadGameState()
	
func _on_CloseButton_pressed():
	$EndStageAlert/EndStage.hide()

func _on_ExitDunButton_pressed():
	if Game.main == null: return
	
	if !end_dungeon:
		$ConfirmDialog/AnimationPlayer.play("fade_out")
		$ConfirmDialog/ColorBg.show()
	else:
		$EndStageAlert/EndStage.show()
		$EndStageAlert/EndStage/TextureRect/RichTextLabel.set_bbcode(dungeon_time)
		#Game.main.curMap = "res://Maps/GreenVeta/GreenVetaVillage/GreenVetaVillage.tscn"
		#Game.main.LoadGameState()

func _on_Clock_timeout():
	ms += 1

func _on_MSTimer_timeout():
	mms += 1
	if mms > 8:
		mms = 0
