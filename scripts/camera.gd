extends Camera2D

func _ready() -> void:
	$LoseScreen.visible = false
	$HUD.visible = true
	$WinScreen.visible = false

func _process(delta: float) -> void:
	var player = get_tree().get_nodes_in_group("Player")[0]
	position.y = player.position.y
	
	if player.health <= 0:
		$LoseScreen.visible = true
	
	var boss = get_tree().get_nodes_in_group("Boss")
	if boss.size() <= 0:
		$WinScreen.visible = true
