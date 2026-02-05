extends Node2D
@onready var tilemap: TileMapLayer = $"../.."

# Coordonnées atlas des tiles d'eau
var water_tiles: Array[Vector2i] = [
	Vector2i(8, 3),
	Vector2i(2, 1),
]

func _physics_process(delta: float) -> void:
	if GameManagement.player == null:
		return

	# Récupérer le CollisionShape2D du player dynamiquement
	var col_shape = GameManagement.player.get_node("CollisionShape2D")
	var col_pos = col_shape.global_position
	var shape = col_shape.shape
	var radius = shape.radius

	# Points de check basés sur le vrai CollisionShape
	var points = [
		col_pos,                          # Centre
		col_pos + Vector2(0, radius),     # Bas
		col_pos + Vector2(0, -radius),    # Haut
		col_pos + Vector2(-radius, 0),    # Gauche
		col_pos + Vector2(radius, 0),     # Droite
	]

	for point in points:
		var tile_pos = tilemap.local_to_map(tilemap.to_local(point))
		var atlas_coords = tilemap.get_cell_atlas_coords(tile_pos)

		if atlas_coords in water_tiles:
			GameManagement.respawn()
			return
