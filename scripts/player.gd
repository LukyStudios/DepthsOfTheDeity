extends CharacterBody2D

@export var playerSpeed = 64
@export var maxJumps = 2
@export var jumpForce = 128
@export var gravity = 4

@export var health = 3

@export var bulletScene:PackedScene

var wingDirection = -1
var facingDirection = true
var usedJumps = 0
var canBeHit = true

var score = 0

func _physics_process(delta: float) -> void:
	var movement = Input.get_vector("left", "right", "down", "up")
	velocity.x = playerSpeed * movement.x
	velocity += gravity * -up_direction
	if movement.x != 0:
		facingDirection = movement.x > 0
	
	# ANIMATIONS
	if facingDirection:
		$Sprite2D.scale.x = 1
	else:
		$Sprite2D.scale.x = -1
	
	var aim : Vector2 = movement.normalized()
	if aim.length() == 0:
		if facingDirection:
			aim = Vector2(1, 0)
		else:
			aim = Vector2(-1, 0)
	if facingDirection:
		$Sprite2D/Bow2D.rotation = -aim.angle()
	else:
		$Sprite2D/Bow2D.rotation = aim.angle() - PI
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_released("attack"):
		attack(aim) 
	
	#if Input.is_action_pressed("move_down"):
		#velocity.y += 1
	#if Input.is_action_pressed("move_up"):
		#velocity.y -= 1
		
	move_and_slide()
	
	if is_on_floor():
		usedJumps = 0

func jump() -> void:
	if usedJumps < maxJumps:
		velocity.y = jumpForce * up_direction.y
		usedJumps += 1

func attack(aim: Vector2) -> void:
	var bullet : RigidBody2D = bulletScene.instantiate()
	bullet.direction = Vector2(aim.x, -aim.y)
	bullet.global_position = global_position
	
	get_tree().current_scene.add_child(bullet)

func takeDamage(damage: int) -> void:
	if canBeHit == true:
		$HitTimer.start(1)
		$AudioStreamPlayer2D.play()
		canBeHit = false
		$Sprite2D.visible = canBeHit
		
		health -= damage
		
		if health <= 0:
			$Sprite2D.visible = false

# Animate Wing Movement
func _on_timer_timeout() -> void:
	$Sprite2D/Wing2D.position.y += wingDirection
	wingDirection *= -1
	
	if !canBeHit:
		$Sprite2D.visible = !$Sprite2D.visible

func _on_hit_timer_timeout() -> void:
	canBeHit = true
	$Sprite2D.visible = true
