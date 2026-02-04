extends Node2D
@onready var mission_label: Label = $CanvasLayer/mission_label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mission_label.hide()
	GameManagement.label_mission = mission_label
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
