extends Node


var BIOME = "ANTARTIQUE"
var temperature: float = 50.0  # 0 = froid, 100 = chaud
var temp_change_rate: float = 5.0  # Vitesse de changement par seconde
var zone_interaction_active = null
var label_mission = null
var zone_interaction = {
	"pingu": [
		"Attraper 5 poissons pour pingu",
		{
			"Question": ["Les poissons se font rares, depuisson passage, je meurs de faim, peux-tu m'aider ?", false],
			"Quête": ["Nombre de poissons", 0, 5],
			"Solution": ["Je te remercie, je te suivrai pour t'aider dans ton combat, en attendant voici un petit quelque chose", false]
		},
		false
	]
}
var current_animal_label: Label = null  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_name = get_tree().current_scene.name
	match level_name:
		"level_1":
			BIOME = "ANTARTIQUE"
		"level_2":
			BIOME = "JUNGLE"
		"level_3":
			BIOME = "DESERT"
		"level_4":
			BIOME = "VILLE"
		"level_5":
			BIOME = "ZOO"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func show_hud_mission(text: String):
	label_mission.text = text
	label_mission.show()
	return
