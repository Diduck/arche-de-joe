extends CharacterBody2D

# --- LIENS ---
@onready var dash_timer: Timer = $DashTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var area_recolte_poisson: Node2D = null
@onready var cooldown_e: Timer = $CouldownE

# --- REGLAGES VITESSE ---
var SPEED = 250.0
var ACCELERATION = 2000
var FRICTION = 2000

# --- ETATS ---
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var e_pressed: bool = false
var e_cooldown: bool = false

# --- DASH ---
var DASH_SPEED: float = 400.0       # Vitesse pendant le dash
var DASH_DURATION: float = 0.15     # Durée du dash en secondes
var dash_time_left: float = 0.0

# --- SAUT (FAUSSE 3D) ---
var z_position: float = 0.0 
var z_velocity: float = 0.0 
var gravity_z: float = 1200.0 
var jump_force: float = -400.0

# --- TEMPERATURE & PROTECTION ---
var temperature: float = 0.0         # J'ai ajouté ça pour que le code marche
var max_temperature: float = 100.0   # J'ai ajouté ça
var vitesse_chauffage: float = 5.0   # J'ai ajouté ça (5 degrés par seconde)

var is_protected: bool = false    # Est-ce qu'on est immunisé ?
var protection_timer: float = 0.0 # Compte à rebours

# --- MEMOIRE ANIMATION ---
var direction_regard = "face" # Se souvient d'où on regarde

func _ready() -> void:
	GameManagement.player = self

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	# --- 1. GESTION TEMPERATURE VS PROTECTION ---
	if is_protected:
		# Si protégé : on décompte le temps seulement
		protection_timer -= delta
		if protection_timer <= 0:
			is_protected = false
			print("Fin de la protection !")
	else:
		# Si PAS protégé : la température monte
		temperature += vitesse_chauffage * delta
		temperature = clamp(temperature, 0, max_temperature)
		
	# ... Le reste de la fonction ne change pas ...

	# --- 2. APPELS ESSENTIELS ---
	gerer_saut(delta)
	update_animations(direction)
	update_physics_values()

	# --- 3. DASH ---
	if Input.is_key_pressed(KEY_SHIFT) and can_dash and direction != Vector2.ZERO:
		# Lancer le dash
		is_dashing = true
		dash_time_left = DASH_DURATION
		dash_direction = direction.normalized()
		can_dash = false
		dash_timer.start()

	if is_dashing:
		# Pendant le dash : vitesse fixe et puissante
		dash_time_left -= delta
		velocity = dash_direction * DASH_SPEED
		if dash_time_left <= 0:
			is_dashing = false
	else:
		# --- 4. DEPLACEMENTS NORMAUX ---
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
	
	# --- 5. INTERACTIONS (Quêtes & Dialogues) ---
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
						GameManagement.zone_interaction[pnj][2] = true
						GameManagement.show_hud_mission(GameManagement.zone_interaction[pnj][0])
						GameManagement.current_animal_label.text = value[0] + " : " + str(value[1]) + " / " + str(value[2]) + "\n -> [E]"
						break
				else:
					if value[1] == false:
						value[1] = null
						if key == "Solution":
							eat()
							GameManagement.hide_hud_mission()
						GameManagement.current_animal_label.text = value[0] + "\n -> [E]"
						break
					elif value[1] == null:
						value[1] = true
						if key == "Solution":
							# Quête terminée, cacher le label
							GameManagement.current_animal_label.hide()
						continue
		else: # Poisson
			if area_recolte_poisson and area_recolte_poisson.poisson_can_recolte == true:
				if GameManagement.current_animal_label: 
					area_recolte_poisson.poisson_can_recolte = false
					GameManagement.zone_interaction["pingu"][1]["Quête"][1] += 1
					GameManagement.current_animal_label.text = str(GameManagement.zone_interaction["pingu"][1]["Quête"][0]) + " : " + str(GameManagement.zone_interaction["pingu"][1]["Quête"][1]) + " / " + str(GameManagement.zone_interaction["pingu"][1]["Quête"][2])
					
	if not Input.is_key_pressed(KEY_E):
		e_pressed = false

# --- FONCTIONS UTILITAIRES ---

func aside_climb(): 
	return false

func update_physics_values():
	if GameManagement.BIOME == "ANTARTIQUE": 
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
	
func gerer_saut(delta):
	if z_position < 0:
		z_velocity += gravity_z * delta
	else:
		z_position = 0
		z_velocity = 0
		if Input.is_action_just_pressed("jump"):
			z_velocity = jump_force
	
	z_position += z_velocity * delta
	sprite.position.y = z_position

# --- GESTION DES ANIMATIONS (CORRIGÉE POUR GAUCHER) ---
func update_animations(direction):
	# 1. DASH + SAUT : la glisse prend le dessus
	if z_position < 0:
		if is_dashing:
			# Glisse prioritaire sur le saut
			if direction_regard == "cote":
				sprite.play("glisse")
				if dash_direction.x < 0:
					sprite.flip_h = false
				else:
					sprite.flip_h = true
			elif direction_regard == "face":
				sprite.play("glisse_devant")
			else:
				sprite.play("jump_devant")
		else:
			if direction_regard == "dos":
				sprite.play("jump_devant")
			else:
				sprite.play("jump")
		return

	# 2. SI ON BOUGE
	if direction.length() > 0:
		# Vers le HAUT (Dos)
		if direction.y < 0:
			sprite.play("run_dos")
			direction_regard = "dos"
			sprite.flip_h = false

		# Vers le BAS (Face)
		elif direction.y > 0:
			if is_dashing:
				sprite.play("glisse_devant")
			else:
				sprite.play("run_face")
			direction_regard = "face"
			sprite.flip_h = false

		# Vers GAUCHE / DROITE (Côté)
		elif direction.x != 0:
			# Animation glisse si on dash sur les côtés
			if is_dashing:
				sprite.play("glisse")
			else:
				sprite.play("run_cote")
			direction_regard = "cote"

			# SPECIALE DEDICACE : Ton sprite regarde à GAUCHE de base.
			if direction.x < 0:
				sprite.flip_h = false  # Gauche = Image normale
			else:
				sprite.flip_h = true   # Droite = Image inversée

	# 3. SI ON S'ARRETE (IDLE)
	else:
		if direction_regard == "dos":
			sprite.play("idle_dos")
		elif direction_regard == "face":
			sprite.play("idle_face")
		elif direction_regard == "cote":
			sprite.play("idle_face") # Pas d'idle de côté, on met face
			
# Fonction appelée quand on mange une glace
func activer_protection_glace():
	is_protected = true
	protection_timer = 60.0 # 60 secondes de protection
	# 1. On remet la température locale à 0
	temperature = 35 
	# 2. IMPORTANT : On remet la température GLOBALE à 0 
	# (C'est ça qui met à jour la barre de vie et la vitesse)
	GameManagement.temperature = 35
	print("Miam ! Température baissée et protégé pour 60 secondes.")
