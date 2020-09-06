extends Control
var helpScene = preload("res://scenes/HelpMenu.tscn") 
func _ready():
	#$CenterContainer/VSplitContainer/VBox/Start_Button.grab_focus()
	$CenterContainer/VSplitContainer/VBox/Exit_Button.connect("pressed",self,"exitPressed")
	$CenterContainer/VSplitContainer/VBox/Help_Button.connect("pressed",self,"helpPressed")
	$CenterContainer/VSplitContainer/VBox/Play_Level_Button.connect("pressed",self,"playLevelPressed")
	$CenterContainer/VSplitContainer/VBox/Credits_Button.connect("pressed",self,"creditsPressed")


func exitPressed():
	get_tree().quit()

func helpPressed():
	var parent = get_parent()
	add_child(helpScene.instance())
	$CenterContainer.visible = false
func playLevelPressed():
	get_tree().change_scene("res://scenes/LevelSelection.tscn")
func creditsPressed():
	get_tree().change_scene("res://scenes/Credits.tscn")
