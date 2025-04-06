extends Area2D

@export var health = 3
@export var damage = 1
@export var enemyScene : PackedScene
var spawning = true

@export var collectableScene : PackedScene

func _process(delta: float) -> void:
	$Timer.paused = !spawning

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		body.queue_free()
		health -= 1
		
		if health <= 0:
			var collectable = collectableScene.instantiate()
			collectable.position = global_position
			get_tree().current_scene.add_child(collectable)
		
			queue_free()
	
	if body.is_in_group("Player"):
		body.takeDamage(damage)

func _on_timer_timeout() -> void:
	var enemy = enemyScene.instantiate()
	enemy.position = $SpawnPoint2D.global_position
	enemy.rotation = 0
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		enemy.direction = Vector2(players[0].global_position.x - global_position.x, 0).normalized()
	
	get_tree().current_scene.add_child(enemy)
