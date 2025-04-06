extends Node2D

var screen_size : Vector2
var safe_distance = 64

var camera : Camera2D

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		if player.position.x < -screen_size.x/2:
			player.position.x = screen_size.x/2
		if player.position.x  > screen_size.x/2:
			player.position.x = -screen_size.x/2
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if enemy.global_position.x < -screen_size.x/2:
			enemy.global_position.x = screen_size.x/2
		if enemy.global_position.x  > screen_size.x/2:
			enemy.global_position.x = -screen_size.x/2
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	var cameraPos = $Camera2D.global_position
	
	var bullets = get_tree().get_nodes_in_group("Bullet")
	for bullet in bullets:
		if (bullet.global_position.y > screen_size.y/2 + safe_distance + cameraPos.y
		|| bullet.global_position.y < -screen_size.y/2 - safe_distance + cameraPos.y
		|| bullet.position.x < -screen_size.x
		|| bullet.position.x > screen_size.x):
			bullet.queue_free()
	
	var spawners = get_tree().get_nodes_in_group("Spawner")
	for spawner in spawners:
		spawner.spawning = !(spawner.global_position.y > screen_size.y/2 + safe_distance + cameraPos.y
		|| spawner.global_position.y < -screen_size.y/2 - safe_distance + cameraPos.y)
