extends Area2D
@onready var poisson_label: Label = $"../poisson_label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	poisson_label.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		poisson_label.show()
		
		print("Joueur entre dans la zone!")
		
func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		poisson_label.hide()

		print("Joueur sorti de la zone!")
