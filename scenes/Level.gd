extends Node2D

var BrokenPipeOverlay = preload("res://scenes/BrokenPipe.tscn")
var crossCursorImage = preload("res://ressources/sprites/iconCross.png")
var ball = preload("res://scenes/Ball.tscn")
#The 3 variables below are used for hovering items below the mouse
#-1 delete
# 0 nothing
# 1 platform
# 2 BrokenPipe
var selectedItem = 0
var previousPosition: Vector2 
var previousItem: int
var previousRotation
# true = running
# false = paused
var editing_status = true

# This is a overlay array used to place nodes/scenes over Tilemap tiles for animations etc.
var positionMap : Dictionary

# 0 = 0deg
# 1 = 90deg
# 2 = 180deg
# 3 = 270deg
var currentRotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$CanvasLayer/IngameUI.find_node("Platform_Button").connect("pressed",self,"_on_PlatformButton_toggled")
	$CanvasLayer/IngameUI.find_node("BrokenPipe_Button").connect("pressed",self,"_on_BrokenPipeButton_toggled")
	$CanvasLayer/IngameUI.find_node("Delete_Button").connect("pressed",self,"_on_DeleteButton_toggled")
	


func _process(_delta):

	pass

func _physics_process(_delta):
	pass

func _unhandled_input(_event):
	if editing_status:
		if $Mainmap.get_cellv($Mainmap.world_to_map(get_global_mouse_position())) != 3:		
			if Input.is_action_pressed("Ingame_Clicked"):
				
				if currentRotation == 0: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
				if currentRotation == 1: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem, true, false ,true)
				if currentRotation == 2: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,true,true,false)
				if currentRotation == 3: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,false,true,true)
				$Mainmap.update_dirty_quadrants()
				get_tree().set_input_as_handled()
				previousPosition = $Mainmap.world_to_map(get_global_mouse_position())
				previousItem = $Mainmap.get_cellv(previousPosition)
				previousRotation = currentRotation
				
				
				if positionMap.has(previousPosition):
					remove_child(positionMap[previousPosition])
					positionMap.erase(previousPosition)
					
				match selectedItem:
					2:
						var node = BrokenPipeOverlay.instance()
						node.add_to_group("BrokenPipeParticleNodes")
						node.position = $Mainmap.map_to_world(previousPosition) + $Mainmap.cell_size/2
						node.visible = true
						node.rotation_degrees= currentRotation*90
						positionMap[previousPosition] = node
						add_child(node)
			else:
				#player hovered no where before
				if previousPosition != null:
					if previousRotation == 0: $Mainmap.set_cellv(previousPosition,previousItem)
					if previousRotation == 1: $Mainmap.set_cellv(previousPosition,previousItem,true, false ,true)
					if previousRotation == 2: $Mainmap.set_cellv(previousPosition,previousItem,true,true,false)
					if previousRotation == 3: $Mainmap.set_cellv(previousPosition,previousItem,false,true,true)
				previousPosition = $Mainmap.world_to_map(get_global_mouse_position())
				var flipped_x = $Mainmap.is_cell_x_flipped(previousPosition.x, previousPosition.y)
				var flipped_y = $Mainmap.is_cell_y_flipped(previousPosition.x, previousPosition.y)
				var transposed = $Mainmap.is_cell_transposed(previousPosition.x, previousPosition.y)
				
				if flipped_x && !flipped_y && transposed: previousRotation = 1
				elif flipped_x && flipped_y && !transposed: previousRotation = 2
				elif !flipped_x && flipped_y && transposed: previousRotation = 3
				else: previousRotation = 0
				
				previousItem = $Mainmap.get_cellv(previousPosition)
				if currentRotation == 0: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
				if currentRotation == 1: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,true, false ,true)
				if currentRotation == 2: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,true,true,false)
				if currentRotation == 3: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,false,true,true)
				
				#$Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
				$Mainmap.update_dirty_quadrants()


	if Input.is_action_just_pressed("Ingame_toggle_start"):
			editing_status = false
			get_tree().paused = false
			
			for member in get_tree().get_nodes_in_group("BrokenPipeParticleNodes"):
				member.find_node("Particles").visible = true
			if get_node_or_null("Ball") != null:
				self.remove_child($Ball)
			#$Ball.visibleState = true
			var ballInstance = ball.instance()
			ballInstance.name = "Ball"
			self.add_child(ballInstance)
			for member in positionMap.values():
				ballInstance.registerBrokenPipe(member)
			$Mainmap.set_cellv(previousPosition,previousItem)
			

		
	if Input.is_action_just_pressed("Ingame_edit_mode"):
		if !editing_status:
			editing_status = true
			self.remove_child($Ball)		
			for member in get_tree().get_nodes_in_group("BrokenPipeParticleNodes"):
				member.find_node("Particles").visible = false
			$CanvasLayer/IngameUI.set_process_input(true)		
			get_tree().paused = true
			#Physics2DServer.set_active(true)
	if Input.is_action_just_pressed("Ingame_rotate"):
		 currentRotation = posmod(currentRotation+1,4)


func _on_PlatformButton_toggled():
	selectedItem = 1
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)

func _on_BrokenPipeButton_toggled():
	selectedItem = 2
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)

func _on_DeleteButton_toggled():
	selectedItem = -1
	if editing_status:
		Input.set_custom_mouse_cursor(crossCursorImage)	
