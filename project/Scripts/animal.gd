extends CharacterBody2D
@onready var animal_label: Label = $animal_label

func _ready() -> void:
	animal_label.hide()

func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		animal_label.show()
		var parent_name = get_parent().name
		GameManagement.zone_interaction_active = parent_name
		GameManagement.current_animal_label = animal_label
		

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		animal_label.hide()
		var parent_name = get_parent().name
		GameManagement.zone_interaction_active = null
		
		
