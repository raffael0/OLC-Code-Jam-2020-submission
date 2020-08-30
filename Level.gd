extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var platformScene = preload("res://Platform.tscn")
var brokenPipeScene = preload("res://BrokenPipe.tscn")

#-1 delete
# 0 nothing
# 1 platform
# 2 BrokenPipe
var selectedItem = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$IngameUI/Platform_Button.connect("pressed",self,"_on_PlatformButton_toggled")
	$IngameUI/BrokenPipe_Button.connect("pressed",self,"_on_BrokenPipeButton_toggled")
	$IngameUI/Delete_Button.connect("pressed",self,"_on_DeleteButton_toggled")
	pass # Replace with function body.


func _process(delta):
	#if Input.is_action_pressed("Ingame_Clicked"):
	#	print(selectedItem)
	#	$TileMap.set_cellv($TileMap.world_to_map(get_global_mouse_position()),selectedItem)
	pass
func _unhandled_input(event):
	if Input.is_action_pressed("Ingame_Clicked"):
		print(selectedItem)
		$TileMap.set_cellv($TileMap.world_to_map(get_global_mouse_position()),selectedItem)
		$TileMap.update_dirty_quadrants()
		get_tree().set_input_as_handled()

func _on_PlatformButton_toggled():
	selectedItem = 1	
func _on_BrokenPipeButton_toggled():
	print("clicked")
	selectedItem = 2
func _on_DeleteButton_toggled():
	selectedItem = -1
