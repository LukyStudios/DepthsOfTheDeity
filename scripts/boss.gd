extends CharacterBody2D

var direction: Vector2 = Vector2(1, 0)
var health = 8

@export var enemyScene : PackedScene
var spawning = true
var jumping = false

@export var moveSpeed = 16
@export var jumpForce = 1048
@export var gravity = 4
@export var gravity_direction = Vector2(0,1)

@export var damage = 1

var canTakeDamage = true

func _physics_process(delta: float) -> void:
	velocity = direction * moveSpeed
	velocity += gravity * -up_direction
	
	$Sprite2D.scale.x = direction.x
	
	if is_on_floor():
		if jumping:
			velocity.y = jumpForce * up_direction.y
			jumping = false
	
	if is_on_wall():
		direction.x = get_wall_normal().x
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		if canTakeDamage:
			$HitTimer.start(1)
			canTakeDamage = false
			$Sprite2D.visible = canTakeDamage
			
			body.queue_free()
			health -= 1
			
			if health <= 0:
				queue_free()
	
	if body.is_in_group("Player"):
		body.takeDamage(damage)

func _on_jump_timer_timeout() -> void:
	jumping = true

func _on_direction_timer_timeout() -> void:
	direction.x *= -1

func _on_spawn_timer_timeout() -> void:
	if spawning: 
		var enemy = enemyScene.instantiate()
		enemy.position = $SpawnPoint2D1.global_position
		enemy.rotation = 0
		enemy.direction.x = -1
		get_tree().current_scene.add_child(enemy)
		
		var enemy2 = enemyScene.instantiate()
		enemy2.position = $SpawnPoint2D2.global_position
		enemy2.rotation = 0
		enemy2.direction.x = 1
		get_tree().current_scene.add_child(enemy2)
		
		var enemy3 = enemyScene.instantiate()
		enemy3.position = $SpawnPoint2D3.global_position
		enemy3.rotation = 0
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			enemy3.direction = Vector2(players[0].global_position.x - global_position.x, 0).normalized()
		get_tree().current_scene.add_child(enemy3)


func _on_flash_timer_timeout() -> void:
	if !canTakeDamage:
		$Sprite2D.visible = !$Sprite2D.visible

func _on_hit_timer_timeout() -> void:
	canTakeDamage = true
	$Sprite2D.visible = true
