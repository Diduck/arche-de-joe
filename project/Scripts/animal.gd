extends CharacterBody2D
@onready var animal_label: Label = $animal_label

func _ready() -> void:
	animal_label.hide()

func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var parent_name = get_parent().name
		# Ne pas afficher le label si l'animal nous suit déjà
		var quest_data = GameManagement.zone_interaction.get(parent_name)
		if quest_data and quest_data[1]["Solution"][1] == true:
			return
		animal_label.show()
		GameManagement.zone_interaction_active = parent_name
		GameManagement.current_animal_label = animal_label

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		animal_label.hide()
		GameManagement.zone_interaction_active = null
		
		
