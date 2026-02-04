extends TextureProgressBar

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = 50  # Test à 50%


func _process(delta: float) -> void:
	# Met à jour la barre avec la température actuelle
	value = GameManagement.temperature
