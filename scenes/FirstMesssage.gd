extends Control


func _ready():
	$CenterContainer/VBoxContainer/Button.connect("pressed",self,"ContinuePressed")	
	$CenterContainer/VBoxContainer/Label/AnimationPlayer.play("Anim")
	yield($CenterContainer/VBoxContainer/Label/AnimationPlayer,"animation_finished")
	$CenterContainer/VBoxContainer/Button.visible=true
	
func ContinuePressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		$CenterContainer/VBoxContainer/Button.visible=true
		$CenterContainer/VBoxContainer/Label/AnimationPlayer.stop()
		$CenterContainer/VBoxContainer/Label.percent_visible=1
