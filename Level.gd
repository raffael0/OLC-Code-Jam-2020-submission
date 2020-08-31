extends Node2D

var BrokenPipeOverlay = preload("res://scenes/BrokenPipe.tscn")
var crossCursorImage = preload("res://ressources/sprites/iconCross.png")
#-1 delete
# 0 nothing
# 1 platform
# 2 BrokenPipe
var selectedItem = 0
var previousPosition: Vector2 
var previousItem: int

# true = running
# false = paused
var pause_status = true
var positionMap
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$IngameUI.find_node("Platform_Button").connect("pressed",self,"_on_PlatformButton_toggled")
	$IngameUI.find_node("BrokenPipe_Button").connect("pressed",self,"_on_BrokenPipeButton_toggled")
	$IngameUI.find_node("Delete_Button").connect("pressed",self,"_on_DeleteButton_toggled")
	
	positionMap = []
	positionMap.resize(512)
	for x in range(512):
		positionMap[x] = []
		positionMap[x].resize(512)
func _process(delta):
	#if Input.is_actiEon_pressed("Ingame_Clicked"):
	#	print(selectedItem)
	#	$Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
	pass

func _unhandled_input(event):
	if pause_status:
		if Input.is_action_pressed("Ingame_Clicked"):
			$Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
			$Mainmap.update_dirty_quadrants()
			get_tree().set_input_as_handled()
			previousPosition = $Mainmap.world_to_map(get_global_mouse_position())
			previousItem = $Mainmap.get_cellv(previousPosition)
		
			if positionMap[previousPosition.x][previousPosition.y] != null:
				remove_child(positionMap[previousPosition.x][previousPosition.y])
				positionMap[previousPosition.x][previousPosition.y] = null
			match selectedItem:
				2:
					var node = BrokenPipeOverlay.instance()
					node.add_to_group("BrokenPipeParticleNodes")
					node.position = $Mainmap.map_to_world(previousPosition)
					node.visible = pause_status
					if positionMap[previousPosition.x] == null:
						positionMap[previousPosition.x] = []
					positionMap[previousPosition.x][previousPosition.y] = node
					add_child(node)
				
		else:
			#player hovered no where before
			if previousPosition != null:
				$Mainmap.set_cellv(previousPosition,previousItem)
			previousPosition = $Mainmap.world_to_map(get_global_mouse_position())
		
			previousItem = $Mainmap.get_cellv(previousPosition)
			$Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
			$Mainmap.update_dirty_quadrants()
		
	
	if Input.is_action_pressed("Ingame_toggle_start"):
		pause_status= !pause_status
		get_tree().paused = pause_status
		
		self.set_process_unhandled_input(true)
		$IngameUI.set_process_input(true)
		if !pause_status:
			$Mainmap.set_cellv(previousPosition,previousItem)
			
		
		
		for member in get_tree().get_nodes_in_group("BrokenPipeParticleNodes"):
			member.find_node("Particles").visible = !pause_status
	
func _on_PlatformButton_toggled():
	selectedItem = 1
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
func _on_BrokenPipeButton_toggled():
	selectedItem = 2
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
func _on_DeleteButton_toggled():
	selectedItem = -1
	if pause_status:
		Input.set_custom_mouse_cursor(crossCursorImage)	
