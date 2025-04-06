extends RigidBody2D

var direction : Vector2 = Vector2(0, 1)
@export var speed = 128

func _ready() -> void:
	$Sprite2D.rotation = direction.angle()

func _physics_process(delta: float) -> void:
	linear_velocity = speed * direction
