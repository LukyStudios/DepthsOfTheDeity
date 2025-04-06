extends Control

var time : float = 0

func _process(delta: float) -> void:
	if !visible:
		time += delta

func _on_visibility_changed() -> void:
	var minutes = int(time/60)%60
	var seconds = int(time)%60
	var milliseconds = int(time*1000)%1000
		
	$TimeLabel.text = "%02d:%02d:%03d" %[minutes, seconds, milliseconds]
		
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		$HealthLabel.text = "%s" % players[0].health
		$ScoreLabel.text = "%s" % players[0].score
