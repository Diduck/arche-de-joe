extends Button

func _on_pressed():
	# 1. On débloque le temps (sinon le nouveau niveau reste figé)
	get_tree().paused = false
	
	# 2. On recharge TOUT le niveau (joueur, poissons, pingu, etc.)
	get_tree().reload_current_scene()
