extends Control


func _ready():
	$CenterContainer/VBoxContainer/LevelSelectionButton.connect("pressed",self,"LevelSelectionButtonPressed")
	$CenterContainer/VBoxContainer/MainMenuButton.connect("pressed",self,"MainMenuButtonPressed")

func LevelSelectionButtonPressed():
	get_tree().change_scene("res://scenes/LevelSelection.tscn")
func MainMenuButtonPressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
