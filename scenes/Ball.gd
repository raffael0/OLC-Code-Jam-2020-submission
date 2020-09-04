 extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var reset_state: bool
var visibleState:bool
# Called when the node enters the scene tree for the first time.
#func _ready():
export var boostIntensity : Vector2 = Vector2(100,-500)
var resetPosition: Vector2

func _ready():
	resetPosition = position
	self.apply_central_impulse(Vector2(300,0))

func registerBrokenPipe(BrokenPipe : Node2D):
	BrokenPipe.find_node("Collisionshape").connect("body_entered_rotation",self,"_on_body_entered")

func _on_body_entered(area_rotation):
	self.apply_central_impulse(boostIntensity.rotated(area_rotation))

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, resetPosition)
		state.linear_velocity = Vector2(0,0)
		self.apply_central_impulse(Vector2(300,0))
		reset_state = false
func moveToOrigin():
	visible = false;
	reset_state = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
