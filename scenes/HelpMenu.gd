extends Control

onready var _transition_rect := $SceneTransitionRect
var backPath := "res://scenes/MainMenu.tscn" 
func _ready():
	$CenterContainer/VBoxContainer/Back_Button.connect("pressed",self,"BackPressed")
	
func BackPressed():
	self.queue_free()
