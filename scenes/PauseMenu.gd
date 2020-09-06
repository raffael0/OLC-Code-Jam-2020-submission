extends Control
signal pauseEnded

var helpScene = preload("res://scenes/HelpMenu.tscn") 
func _ready():
	print($CenterContainer/VBoxContainer/Continue_Button.connect("pressed",self,"ContinuePressed"))
	$CenterContainer/VBoxContainer/Help_Button.connect("pressed",self,"HelpPressed")
	$CenterContainer/VBoxContainer/MainMenu_Button.connect("pressed",self,"MainMenuPressed")
	
func ContinuePressed():
	get_tree().paused = false
	emit_signal("pauseEnded")
	queue_free()
func HelpPressed():
	var helpSceneInstance = helpScene.instance()
	helpSceneInstance.backPath = "res://scenes/PauseMenu.tscn"
	get_parent().add_child(helpSceneInstance)
	#get_tree().change_scene_to(helpSceneInstance)
func MainMenuPressed():
	emit_signal("pauseEnded")
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	
