extends Node2D


func _ready():
	$Level.connect("LevelDone",self,"LevelDone")
	
func LevelDone():
	get_tree().change_scene("res://scenes/2ndMesssage.tscn")
