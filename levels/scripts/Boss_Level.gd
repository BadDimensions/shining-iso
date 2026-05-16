class_name BossLevel extends Level

@onready var boss: KnightBoss = $Actors/Knight
@onready var position_markers: Node2D = $Actors/PositionMarkers


func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	_setup_boss()
	

func _setup_boss() -> void:
	if boss == null:
		push_error("Boss not found in scene")
		return

	var points: Array[Vector2] = []

	for marker in position_markers.get_children():
		points.append(marker.global_position)

	boss.set_teleport_positions(points)

	
