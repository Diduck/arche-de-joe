extends CharacterBody2D

const ANIMAL = preload("uid://kp7raweoxcps")

func _ready() -> void:
	GameManagement.register_character(self)

func _exit_tree() -> void:
	GameManagement.unregister_character(self)

func _physics_process(delta: float) -> void:
	pass
