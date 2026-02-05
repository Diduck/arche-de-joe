extends CharacterBody2D

const ANIMAL = preload("uid://kp7raweoxcps")

var is_following: bool = false
var FOLLOW_SPEED: float = 200.0
var FOLLOW_DISTANCE: float = 64.0  # 1 bloc de distance

func _ready() -> void:
	GameManagement.register_character(self)

func _exit_tree() -> void:
	GameManagement.unregister_character(self)

func _physics_process(delta: float) -> void:
	# Vérifier si la quête est terminée (Solution acceptée)
	if not is_following:
		var quest_data = GameManagement.zone_interaction["pingu"][1]
		if quest_data["Solution"][1] == true:
			is_following = true
		return

	# Suivre le joueur
	if GameManagement.player == null:
		return

	var distance = global_position.distance_to(GameManagement.player.global_position)

	if distance > FOLLOW_DISTANCE:
		var direction = (GameManagement.player.global_position - global_position).normalized()
		velocity = direction * FOLLOW_SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 400 * delta)

	move_and_slide()
