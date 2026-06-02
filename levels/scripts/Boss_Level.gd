class_name BossLevel extends Level

@onready var boss: KnightBoss = $Actors/Knight
@onready var position_markers: Node2D = $Actors/PositionMarkers
@onready var collision_wall: LevelTileMap = $CollisionWall
@onready var boss_trigger: Area2D = $BossTrigger


func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	_setup_boss()
	boss_trigger.triggered.connect(_on_boss_started)
	boss.enemy_destroyed.connect(_on_boss_defeated)

func _setup_boss() -> void:
	if boss == null:
		push_error("Boss not found in scene")
		return

	var points: Array[Vector2] = []

	for marker in position_markers.get_children():
		points.append(marker.global_position)

	boss.set_teleport_positions(points)
func _on_boss_started():
	#print("Boss started")
	collision_wall.enabled = true  
	boss.change_state(boss.STATE.WALK)
	HealthGui.show_boss_health("Ruin Knight")
	
func _on_boss_defeated():
	print("boss_defeated")
	collision_wall.enabled = false
	await get_tree().create_timer(3.0).timeout
	resume_music()
	HealthGui.hide_boss_health()
