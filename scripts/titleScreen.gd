extends Control

@export var level : PackedScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_packed(level)
