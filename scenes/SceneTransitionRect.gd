extends ColorRect
export(String, FILE, "*.tscn") var next_scene_path
export var transition_on_load := true
onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	if transition_on_load: _anim_player.play_backwards("Fade")

func transition_to(_next_scene := next_scene_path)-> void:
	_anim_player.play("Fade")
	get_tree().change_scene(_next_scene)	
	yield(_anim_player,"animation_finished")
	
