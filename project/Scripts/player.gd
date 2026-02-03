extends CharacterBody2D
@onready var game_management = get_parent().get_node("GameManagement")


const SPEED = 300.0
var ACCELERATION = 2000 #pas de glisse
var FRICTION = 2000 #pas de glisse


func _physics_process(delta: float) -> void:
	# Vue du dessus - pas de gravité
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	update_physics_values()
	if direction != Vector2.ZERO:
		# On accélère vers la direction souhaitée
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		# On glisse vers l'arrêt total
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	
func update_physics_values():
	if game_management.BIOME == "ANTARTIQUE": #glisser
		ACCELERATION = 400.0
		FRICTION = 150.0
	else:
		ACCELERATION = 2000.0
		FRICTION = 2000.0
