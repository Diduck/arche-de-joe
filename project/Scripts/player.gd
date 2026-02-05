extends CharacterBody2D
@onready var dash_timer: Timer = $DashTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_recolte_poisson: Node2D = $"../Poissons/AreaRecoltePoisson"
@onready var cooldown_e: Timer = $CouldownE

var SPEED = 250.0
var ACCELERATION = 2000
var FRICTION = 2000

var can_dash: bool = true
var e_pressed: bool = false
var e_cooldown: bool = false

func _ready() -> void:
	GameManagement.player = self

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
	if Input.is_key_pressed(KEY_E) and not e_pressed and not e_cooldown and GameManagement.zone_interaction_active != null:
		e_pressed = true
		e_cooldown = true
		cooldown_e.start()
		var pnj = GameManagement.zone_interaction_active
		if pnj != "poisson":
			var quest_data = GameManagement.zone_interaction[pnj][1]
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
						if key == "Solution":
							eat()
							GameManagement.hide_hud_mission()
						GameManagement.current_animal_label.text = value[0]
						break
					elif value[1] == null:
						value[1] = true		
						continue
		else: #Interaction poisson
			if area_recolte_poisson.poisson_can_recolte == true:
				if GameManagement.current_animal_label: #A d'abord parlé à l'animal
					area_recolte_poisson.poisson_can_recolte = false
					GameManagement.zone_interaction["pingu"][1]["Quête"][1] += 1
					GameManagement.current_animal_label.text = str(GameManagement.zone_interaction["pingu"][1]["Quête"][0]) + " : " + str(GameManagement.zone_interaction["pingu"][1]["Quête"][1]) + " / " + str(GameManagement.zone_interaction["pingu"][1]["Quête"][2])
					print("Le joueur vient de récolter un poisson : " + str(GameManagement.zone_interaction["pingu"][1]["Quête"][1]) + " / " + str(GameManagement.zone_interaction["pingu"][1]["Quête"][2]))
					
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


func eat():
	GameManagement.diminuer_temperature(20)

func _on_couldown_e_timeout() -> void:
	e_cooldown = false
	
	
