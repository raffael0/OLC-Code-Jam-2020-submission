extends Camera2D

export var velocity = 20
var screenSize: Vector2


const ZOOM_MAX = Vector2(1,1)
const ZOOM_MIN = Vector2(8,8)
const ZOOM_SPEED = 1
var zoom_in = false
var zoom_out = false




func _ready():
	screenSize = get_viewport_rect().size
	
func _physics_process(delta):
	if Input.is_action_pressed("Camera_Top"):
		#if (position.y > self.limit_top + velocity):
			self.position.y -= velocity
	if Input.is_action_pressed("Camera_Bottom"):
		#if position.y  < self.limit_bottom - velocity:
			self.position.y += velocity
	if Input.is_action_pressed("Camera_Right"):
		#if position.x < self.limit_right-velocity:
			self.position.x += velocity
	if Input.is_action_pressed("Camera_Left"):
		#if position.x > self.limit_left + velocity:
			self.position.x -= velocity
	if Input.is_action_just_released("ZOOM_UP") and zoom > ZOOM_MAX:
		zoom_in = true
		zoom_out = false
	if Input.is_action_just_released("ZOOM_DOWN") and zoom < ZOOM_MIN:
		zoom_out = true
	if zoom_in == true :
		zoom = lerp(zoom, zoom - Vector2(0.1,0.1), ZOOM_SPEED)
		yield(get_tree().create_timer(0.10), "timeout")
		zoom_in = false
		print(zoom)
	if zoom_out == true :
		zoom = lerp(zoom, zoom + Vector2(0.1,0.1), ZOOM_SPEED)
		print(zoom)
		yield(get_tree().create_timer(0.10), "timeout")
		zoom_out = false
