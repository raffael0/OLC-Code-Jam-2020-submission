extends Control

onready var _transition_rect := $SceneTransitionRect
func _ready():
	$CenterContainer/VSplitContainer/VBox/Start_Button.grab_focus()
	$CenterContainer/VSplitContainer/VBox/Start_Button.connect("pressed",self,"startPressed")
	$CenterContainer/VSplitContainer/VBox/Exit_Button.connect("pressed",self,"exitPressed")
	$CenterContainer/VSplitContainer/VBox/Settings_Button.connect("pressed",self,"settingsPressed")
	$CenterContainer/VSplitContainer/VBox/Play_Level_Button.connect("pressed",self,"playLevelPressed")
	
func startPressed():
	#_transition_rect.transition_to()
	pass
func exitPressed():
	get_tree().quit()

func settingsPressed():
	pass
func playLevelPressed():
	_transition_rect.transition_to("res://scenes/LevelSelection.tscn")
