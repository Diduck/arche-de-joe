extends Area2D
@onready var poisson_label: Label = $"../poisson_label"
@onready var spawn_timer: Timer = $SpawnTimer
@onready var disponible_timer: Timer = $DisponibleTimer

var poisson_can_recolte = false
var player_in_zone = false

func _ready() -> void:
	poisson_label.hide()
	start_spawn_timer()

func start_spawn_timer() -> void:
	var random_time = randf_range(3.0, 6.0)
	spawn_timer.wait_time = random_time
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	poisson_can_recolte = true
	if player_in_zone:
		poisson_label.text = "Poisson disponible ! Appuie sur E"
	disponible_timer.wait_time = 0.7
	disponible_timer.start()

func _on_disponible_timer_timeout() -> void:
	poisson_can_recolte = false
	if player_in_zone:
		poisson_label.text = "Attends qu'un poisson apparaisse..."
	start_spawn_timer()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_zone = true
		if poisson_can_recolte:
			poisson_label.text = "Poisson disponible ! Appuie sur E"
		else:
			poisson_label.text = "Attends qu'un poisson apparaisse..."
		poisson_label.show()
		GameManagement.zone_interaction_active = "poisson"

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_zone = false
		poisson_label.hide()
		GameManagement.zone_interaction_active = null
