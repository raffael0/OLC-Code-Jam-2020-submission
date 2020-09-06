extends Control


func _ready():
	$CenterContainer/VBoxContainer/BackButton.connect("pressed",self,"backPressed")

func backPressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
