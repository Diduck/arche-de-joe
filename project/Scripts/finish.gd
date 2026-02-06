extends Area2D

# On fait le lien vers le calque de victoire
@onready var interface = $"../VictoireInterface"

func _ready():
	# On connecte le signal de détection de Joe
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Si c'est bien le joueur (Joe) qui entre dans la zone
	if body.name == "player":
		# 1. On affiche le menu de victoire
		interface.visible = true
		
		# 2. On fige le jeu (Joe ne peut plus tomber ou bouger)
		get_tree().paused = true
