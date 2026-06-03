class_name BossLevel extends Level

@onready var player = PlayerManager.player

@onready var boss: KnightBoss = $Actors/Knight
@onready var position_markers: Node2D = $Actors/PositionMarkers
@onready var collision_wall: LevelTileMap = $CollisionWall
@onready var boss_trigger: Area2D = $BossTrigger
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var cutscene_camera: Camera2D = $CutsceneCamera


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
	collision_wall.enabled = true  
	player.input_enabled = false
	boss.change_state(boss.STATE.IDLE)
	player.get_node("Camera2D").enabled = false
	cutscene_player.play("boss_intro")
	await cutscene_player.animation_finished 
	player.get_node("Camera2D").enabled = true
	player.input_enabled = true
	boss.change_state(boss.STATE.WALK)
	HealthGui.show_boss_health("Ruin Knight")
	
func _on_boss_defeated():
	print("boss_defeated")
	collision_wall.enabled = false
	HealthGui.hide_boss_health()
	await get_tree().create_timer(3.0).timeout
	resume_music()
	
