extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal body_entered_rotation(area_rotation)

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_vec = gravity_vec.rotated(get_parent().rotation)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
