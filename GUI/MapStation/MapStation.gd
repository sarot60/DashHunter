extends Control

#class_name MapStation


onready var gvdun1 = $Bg/ScrollContainer/VBoxContainer/GVDun1
onready var gvdun2 = $Bg/ScrollContainer/VBoxContainer/GVDun2
onready var gvdun3 = $Bg/ScrollContainer/VBoxContainer/GVDun3
onready var gvdun4 = $Bg/ScrollContainer/VBoxContainer/GVDun4
onready var gvdun5 = $Bg/ScrollContainer/VBoxContainer/GVDun5

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	var _Con1 = gvdun1.get_node("GVDun1Button").connect("pressed", self, "_on_GVDun1Button_pressed")
	var _Con2 = gvdun2.get_node("GVDun2Button").connect("pressed", self, "_on_GVDun2Button_pressed")
	var _Con3 = gvdun3.get_node("GVDun3Button").connect("pressed", self, "_on_GVDun3Button_pressed")
	var _Con4 = gvdun4.get_node("GVDun4Button").connect("pressed", self, "_on_GVDun4Button_pressed")
	var _Con5 = gvdun5.get_node("GVDun5Button").connect("pressed", self, "_on_GVDun5Button_pressed")

# ------------------------ Signals --------------------------------------

func _on_GVDun1Button_pressed():
	if Game.main == null: return
	
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaDungeon1/GreenVetaDungeon1.tscn"
	Game.main.LoadGameState()
	
func _on_GVDun2Button_pressed():
	if Game.main == null: return
	
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaDungeon2/GreenVetaDungeon2.tscn"
	Game.main.LoadGameState()
	
func _on_GVDun3Button_pressed():
	if Game.main == null: return
	
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaDungeon3/GreenVetaDungeon3.tscn"
	Game.main.LoadGameState()
	
func _on_GVDun4Button_pressed():
	if Game.main == null: return
	
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaDungeon4/GreenVetaDungeon4.tscn"
	Game.main.LoadGameState()
	
func _on_GVDun5Button_pressed():
	if Game.main == null: return
	
	Game.main.curMap = "res://Maps/GreenVeta/GreenVetaDungeon5/GreenVetaDungeon5.tscn"
	Game.main.LoadGameState()
