extends Control

var backPath := "res://scenes/MainMenu.tscn" 
func _ready():
	$CenterContainer/VBoxContainer/Back_Button.connect("pressed",self,"BackPressed")
	
func BackPressed():
	if(get_parent().find_node("CenterContainer") != null):
		get_parent().find_node("CenterContainer").visible = true	
	self.queue_free()
