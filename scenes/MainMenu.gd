extends Control
var helpScene = preload("res://scenes/HelpMenu.tscn") 
onready var _transition_rect := $SceneTransitionRect
func _ready():
	#$CenterContainer/VSplitContainer/VBox/Start_Button.grab_focus()
	$CenterContainer/VSplitContainer/VBox/Start_Button.connect("pressed",self,"startPressed")
	$CenterContainer/VSplitContainer/VBox/Exit_Button.connect("pressed",self,"exitPressed")
	$CenterContainer/VSplitContainer/VBox/Help_Button.connect("pressed",self,"helpPressed")
	$CenterContainer/VSplitContainer/VBox/Play_Level_Button.connect("pressed",self,"playLevelPressed")
	print($CenterContainer/VSplitContainer/VBox/Play_Level_Button.name)
func startPressed():
	#_transition_rect.transition_to()
	pass
func exitPressed():
	get_tree().quit()

func helpPressed():
	var helpSceneInstance
	get_parent().add_child(helpScene.instance())
	visible = false
func playLevelPressed():
	_transition_rect.transition_to("res://scenes/LevelSelection.tscn")
