extends Area2D

var score = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.score += score
		queue_free()
