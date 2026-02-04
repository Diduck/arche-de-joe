extends Timer
@onready var player = get_parent()
@onready var texture_progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar

func _ready() -> void:
	wait_time = 5.0
	one_shot = false  # Répète en boucle
	start()


func _on_timeout() -> void:
	var countUp = 1.0
	if GameManagement.BIOME == "ANTARTIQUE": #Augmente + ou - la température selon biome
		countUp = 1.0
		
	
	if !(GameManagement.temperature >= 100): #Pas augmenter + que 100 malgrès le clamp sur le HUD, je veux pas une températeur + élevé pour gérer facilement les glaces 
		augmenter_temperature(1.0)
	if (GameManagement.temperature >= 65): #Ralentir le player
		player.SPEED = 100
	else:
		player.SPEED = 250
	

func augmenter_temperature(amount: float = 1.0) -> void:
	GameManagement.temperature = clamp(GameManagement.temperature + amount, 0, 100)
	

func diminuer_temperature(amount: float = 1.0) -> void:
	GameManagement.temperature = clamp(GameManagement.temperature - amount, 0, 100)
	
