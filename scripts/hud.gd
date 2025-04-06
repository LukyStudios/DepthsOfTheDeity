extends Control

@export var healthImage : Texture2D
var scoreCount : String = ""

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		scoreCount = "%s" % players[0].score
		$ScoreLabel.text = scoreCount
		
		var playerHealth = players[0].health
		var healthImages = get_tree().get_nodes_in_group("HealthImage")
		
		if (healthImages.size() != playerHealth):
			for hImage in healthImages:
				hImage.queue_free()
			
			for i in range(playerHealth):
				var healthBar = TextureRect.new()
				healthBar.add_to_group("HealthImage")
				self.add_child(healthBar)
				healthBar.texture = healthImage
				healthBar.size = Vector2(8,8)
				healthBar.position = Vector2(18, 0) + i * Vector2(8, 0)
