extends Control

func _ready():
	$CenterContainer/VBoxContainer/Back_Button.connect("pressed",self,"Back_Pressed")
	$CenterContainer/VBoxContainer/GridContainer/Level1_Button.connect("pressed",self,"Level_Pressed",[1])
	$CenterContainer/VBoxContainer/GridContainer/Level2_Button.connect("pressed",self,"Level_Pressed",[2])
	$CenterContainer/VBoxContainer/GridContainer/Level3_Button.connect("pressed",self,"Level_Pressed",[3])
	$CenterContainer/VBoxContainer/GridContainer/Level4_Button.connect("pressed",self,"Level_Pressed",[4])
	$CenterContainer/VBoxContainer/GridContainer/Level5_Button.connect("pressed",self,"Level_Pressed",[5])
	$CenterContainer/VBoxContainer/GridContainer/Level6_Button.connect("pressed",self,"Level_Pressed",[6])
	
	for level in Global.UnlockedLeved:
		find_node("Level"+str(level)+"_Button").disabled = false

func Back_Pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	
func Level_Pressed(arr):
	get_tree().change_scene("res://scenes/Level" + str(arr)+".tscn")
