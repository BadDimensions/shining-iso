class_name PlayerCamera extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.TileMapBoundsChanged.connect(UpdateLimitsFromBounds)
	UpdateLimitsFromBounds(LevelManager.current_tilemap_bounds)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func UpdateLimitsFromBounds(bounds: Array[Vector2]):
	if bounds.size() != 2:
		return

	var padding = Vector2(300, 200)
	limit_left   = int(bounds[0].x - padding.x)
	limit_top    = int(bounds[0].y - padding.y)
	limit_right  = int(bounds[1].x + padding.x)
	limit_bottom = int(bounds[1].y + padding.y)
