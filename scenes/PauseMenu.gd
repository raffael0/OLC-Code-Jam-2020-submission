extends Control

onready var _transition_rect := $SceneTransitionRect
var helpScene = preload("res://scenes/HelpMenu.tscn") 
func _ready():
	print($CenterContainer/VBoxContainer/Continue_Button.connect("pressed",self,"ContinuePressed"))
	$CenterContainer/VBoxContainer/Help_Button.connect("pressed",self,"HelpPressed")
	$CenterContainer/VBoxContainer/MainMenu_Button.connect("pressed",self,"MainMenuPressed")
	
func ContinuePressed():
	get_tree().paused = false
	queue_free()
func HelpPressed():
	var helpSceneInstance = helpScene.instance()
	helpSceneInstance.backPath = "res://scenes/PauseMenu.tscn"
	helpSceneInstance.find_node("SceneTransitionRect").transition_on_load = false
	get_parent().add_child(helpSceneInstance)
	#get_tree().change_scene_to(helpSceneInstance)
func MainMenuPressed():
	get_tree().paused = false
	_transition_rect.transition_to("res://scenes/MainMenu.tscn")
	
