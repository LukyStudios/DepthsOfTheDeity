extends CharacterBody2D

var direction: Vector2 = Vector2(1, 0)
@export var moveSpeed = 32
@export var gravity = 64
@export var gravity_direction = Vector2(0,1)
@export var damage = 1

@export var collectableScene : PackedScene

func _physics_process(delta: float) -> void:
	velocity = direction * moveSpeed
	velocity += gravity * gravity_direction
	
	$Sprite2D.scale.x = direction.x
	
	if is_on_wall():
		direction.x = get_wall_normal().x
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		var collectable = collectableScene.instantiate()
		collectable.position = global_position
		get_tree().current_scene.add_child(collectable)
		
		body.queue_free()
		queue_free()
	
	if body.is_in_group("Player"):
		body.takeDamage(damage)
		queue_free()
