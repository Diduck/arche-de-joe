extends CharacterBody2D
@onready var dash_timer: Timer = $DashTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var SPEED = 250.0
var ACCELERATION = 2000
var FRICTION = 2000

var can_dash: bool = true
var e_pressed: bool = false  # ← Déplacé ici !

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	update_physics_values()
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		if direction.x > 0:
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

	if Input.is_key_pressed(KEY_SHIFT) and can_dash:
		if !aside_climb():
			velocity = velocity.move_toward(direction * SPEED * 3, 2000 * delta)
			can_dash = false
			dash_timer.start()
	
	# Interaction PNJ
	if Input.is_key_pressed(KEY_E) and not e_pressed and GameManagement.zone_interaction_active != null:
		e_pressed = true
		var pnj = GameManagement.zone_interaction_active
		var quest_data = GameManagement.zone_interaction[pnj][1]
		print("E pressed for " + pnj)
		
		for key in quest_data:
			var value = quest_data[key]
			
			if key == "Quête":
				if value[1] < value[2]:
					GameManagement.zone_interaction[pnj][2] = true #active la mission pour le hud
					GameManagement.show_hud_mission(GameManagement.zone_interaction[pnj][0])
					GameManagement.current_animal_label.text = value[0] + " : " + str(value[1]) + " / " + str(value[2])
					break
			else:
				if value[1] == false:
					value[1] = null
					GameManagement.current_animal_label.text = value[0]
					break
				elif value[1] == null:
					value[1] = true		
					continue
	
	if not Input.is_key_pressed(KEY_E):
		e_pressed = false


func aside_climb(): #Si il il y a l'action de grimper ou non à coté de lui
	return false

func update_physics_values():
	if GameManagement.BIOME == "ANTARTIQUE": #glisser
		ACCELERATION = 400.0
		FRICTION = 150.0
	else:
		ACCELERATION = 2000.0
		FRICTION = 2000.0

func _on_dash_timer_timeout() -> void:
	can_dash = true

	
	
