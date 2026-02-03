extends Node


var BIOME = "ANTARTIQUE"

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
