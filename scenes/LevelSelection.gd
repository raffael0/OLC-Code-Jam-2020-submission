extends Control

onready var _transition_rect := $SceneTransitionRect
func _ready():
	$CenterContainer/VBoxContainer/Back_Button.connect("pressed",self,"Back_Pressed")
	$CenterContainer/VBoxContainer/GridContainer/Level1_Button.connect("pressed",self,"Level1_Pressed")
func Back_Pressed():
	_transition_rect.transition_to("res://scenes/MainMenu.tscn")
	
func Level1_Pressed():
	_transition_rect.transition_to("res://scenes/Level1.tscn")
