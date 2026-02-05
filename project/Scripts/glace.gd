extends Area2D

# On prépare la connexion avec le texte qu'on vient de créer
@onready var mon_texte = $Label 

var joueur_sur_zone = null

func _ready():
	# Au démarrage, on cache le texte
	mon_texte.visible = false
	
	# On branche les détections
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	# Si le joueur est là ET qu'il appuie sur E
	if joueur_sur_zone != null and Input.is_key_pressed(KEY_E):
		print("MIAM ! Glace mangée.")
		joueur_sur_zone.activer_protection_glace()
		queue_free() # La glace disparaît

# Quand on ENTRE sur la glace
func _on_body_entered(body):
	# On vérifie si c'est bien Joe (en vérifiant s'il a la fonction de protection)
	if body.has_method("activer_protection_glace"):
		joueur_sur_zone = body
		mon_texte.visible = true # AFFICHE LE TEXTE !
		mon_texte.text = "E : Se rafraîchir" # Tu peux changer le message ici

# Quand on SORT de la glace
func _on_body_exited(body):
	if body == joueur_sur_zone:
		joueur_sur_zone = null
		mon_texte.visible = false # CACHE LE TEXTE !
