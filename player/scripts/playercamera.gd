class_name PlayerCamera extends Camera2D

@export_range(0,1,0.05,"or_greater") var shake_power : float = 0.5 #shake strength
@export var shake_max_offset : float = 5.0 #max shake in pixels
@export var shake_decay : float = 1.0
var shake_trauma : float = 0.0

func _ready() -> void:
	LevelManager.TileMapBoundsChanged.connect(UpdateLimitsFromBounds)
	UpdateLimitsFromBounds(LevelManager.current_tilemap_bounds)
	PlayerManager.camera_shook.connect(add_camera_shake)
	pass 


func _physics_process(delta : float) -> void:
	if shake_trauma > 0:
		shake_trauma = max(shake_trauma - shake_decay * delta,0)
		shake()
	pass
	
func add_camera_shake(val : float) -> void:
	shake_trauma = val
	pass
	
func shake() -> void:
	var amount = pow(shake_trauma * shake_power, 2)
	offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * shake_max_offset * amount
	pass
	
func UpdateLimitsFromBounds(bounds: Array[Vector2]):
	if bounds.size() != 2:
		return

	var padding = Vector2(300, 200)
	limit_left   = int(bounds[0].x - padding.x)
	limit_top    = int(bounds[0].y - padding.y)
	limit_right  = int(bounds[1].x + padding.x)
	limit_bottom = int(bounds[1].y + padding.y)
