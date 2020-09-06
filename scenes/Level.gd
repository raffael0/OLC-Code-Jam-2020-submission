extends Node2D

export var maxPipes : int = 0
export var maxBrokenPipes : int = 0
export var levelId : int

var BrokenPipeOverlay = preload("res://scenes/BrokenPipe.tscn")
var crossCursorImage = preload("res://ressources/sprites/iconCross.png")
var ball = preload("res://scenes/Ball.tscn")
var pauseMenu = preload("res://scenes/PauseMenu.tscn")
var levelCompletedMenu = preload("res://scenes/LevelCompletedMenu.tscn")

signal LevelDone

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
var pauseAllowed = true
# 0 = 0deg
# 1 = 90deg
# 2 = 180deg
# 3 = 270deg
var currentRotation = 0

const pipeIndex = 4
const brokenPipeIndex = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$CanvasLayer/IngameUI.find_node("Platform_Button").connect("pressed",self,"_on_PlatformButton_toggled")
	$CanvasLayer/IngameUI.find_node("BrokenPipe_Button").connect("pressed",self,"_on_BrokenPipeButton_toggled")
	$CanvasLayer/IngameUI.find_node("Delete_Button").connect("pressed",self,"_on_DeleteButton_toggled")
	$CanvasLayer/PlayPauseIcon.frame=1
	$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/UsedBrokenPipesLabel.text = "BrokenPipes used: 0/" + str(maxBrokenPipes)
	$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/UsedPipesLabel.text = "Pipes used: 0/" + str(maxPipes)
	$BallGoal.connect("body_entered",self,"_on_ballGoalEntered")
func _process(_delta):

	pass

func _physics_process(_delta):
	pass

func _unhandled_input(_event):
	if editing_status:
		if $Mainmap.get_cellv($Mainmap.world_to_map(get_global_mouse_position())) != 3:		
			if Input.is_action_pressed("Ingame_Clicked"):
				if previousPosition != null:
						if previousRotation == 0: $Mainmap.set_cellv(previousPosition,previousItem)
						if previousRotation == 1: $Mainmap.set_cellv(previousPosition,previousItem,true, false ,true)
						if previousRotation == 2: $Mainmap.set_cellv(previousPosition,previousItem,true,true,false)
						if previousRotation == 3: $Mainmap.set_cellv(previousPosition,previousItem,false,true,true)
				if ($Mainmap.get_used_cells_by_id(pipeIndex).size()< maxPipes && selectedItem == pipeIndex) || ($Mainmap.get_used_cells_by_id(brokenPipeIndex).size()< maxBrokenPipes && selectedItem == brokenPipeIndex) || selectedItem == -1:
					var currentIndex = $Mainmap.get_cellv($Mainmap.world_to_map(get_global_mouse_position()))
					if ((currentIndex == brokenPipeIndex) || (currentIndex == pipeIndex) || currentIndex == -1) :
						if currentRotation == 0: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem)
						if currentRotation == 1: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem, true, false ,true)
						if currentRotation == 2: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,true,true,false)
						if currentRotation == 3: $Mainmap.set_cellv($Mainmap.world_to_map(get_global_mouse_position()),selectedItem,false,true,true)
						$Mainmap.update_dirty_quadrants()
						get_tree().set_input_as_handled()
						previousPosition = $Mainmap.world_to_map(get_global_mouse_position())
						previousItem = $Mainmap.get_cellv(previousPosition)
						previousRotation = currentRotation
	
						#Update Labels
						$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/UsedBrokenPipesLabel.text = ("BrokenPipes used:"+ str($Mainmap.get_used_cells_by_id(brokenPipeIndex).size()) + "/"+ str(maxBrokenPipes))
						$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/UsedPipesLabel.text = ("Pipes used: " + str($Mainmap.get_used_cells_by_id(pipeIndex).size()) +"/"+str(maxPipes))
	
						if positionMap.has(previousPosition):
							remove_child(positionMap[previousPosition])
							positionMap.erase(previousPosition)
							
						match selectedItem:
							brokenPipeIndex:
								var node = BrokenPipeOverlay.instance()
								node.add_to_group("BrokenPipeParticleNodes")
								node.position = $Mainmap.map_to_world(previousPosition) + $Mainmap.cell_size/2
								node.visible = true
								node.rotation_degrees= currentRotation*90
								positionMap[previousPosition] = node
								add_child(node)
			else:
				if ($Mainmap.get_used_cells_by_id(pipeIndex).size() -1 <= maxPipes && selectedItem == pipeIndex) || ($Mainmap.get_used_cells_by_id(brokenPipeIndex).size()-1 <= maxBrokenPipes && selectedItem == brokenPipeIndex) || selectedItem == -1:
					var currentIndex = $Mainmap.get_cellv($Mainmap.world_to_map(get_global_mouse_position()))
					if ((currentIndex == brokenPipeIndex) || (currentIndex == pipeIndex) || currentIndex == -1) :
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
			
			if previousPosition != null:
						if previousRotation == 0: $Mainmap.set_cellv(previousPosition,previousItem)
						if previousRotation == 1: $Mainmap.set_cellv(previousPosition,previousItem,true, false ,true)
						if previousRotation == 2: $Mainmap.set_cellv(previousPosition,previousItem,true,true,false)
						if previousRotation == 3: $Mainmap.set_cellv(previousPosition,previousItem,false,true,true)
			
			$CanvasLayer/PlayPauseIcon.frame=0

		
	if Input.is_action_just_pressed("Ingame_edit_mode"):
		if !editing_status:
			$CanvasLayer/PlayPauseIcon.frame=1
			
			editing_status = true
			self.remove_child($Ball)		
			for member in get_tree().get_nodes_in_group("BrokenPipeParticleNodes"):
				member.find_node("Particles").visible = false
			$CanvasLayer/IngameUI.set_process_input(true)		
			get_tree().paused = true
			#Physics2DServer.set_active(true)
	if Input.is_action_just_pressed("Ingame_rotate"):
		 currentRotation = posmod(currentRotation+1,4)
	if Input.is_action_just_pressed("ui_cancel"):
		if pauseAllowed:
			if get_node_or_null("CanvasLayer/PauseMenu") == null:
				var menu = pauseMenu.instance()
				$CanvasLayer.add_child(menu)
				get_tree().paused = true
			else:
				$CanvasLayer.remove_child($CanvasLayer/PauseMenu)


func _on_PlatformButton_toggled():
	selectedItem = pipeIndex
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)

func _on_BrokenPipeButton_toggled():
	selectedItem = brokenPipeIndex
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)

func _on_DeleteButton_toggled():
	selectedItem = -1
	if editing_status:
		Input.set_custom_mouse_cursor(crossCursorImage)	
func _on_ballGoalEntered(body):
	emit_signal("LevelDone")
	Global.UnlockedLeved.append(levelId+1)
	var levelCompletedMenuInstance = levelCompletedMenu.instance()
	pauseAllowed = false
	$CanvasLayer.add_child(levelCompletedMenuInstance)
