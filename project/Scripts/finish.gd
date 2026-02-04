extends Node2D
@onready var level_1: Node2D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("Tu as fini le jeu")
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
