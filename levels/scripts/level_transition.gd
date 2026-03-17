@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Setting")
@export_range(1, 12, 1, "or_greater") var size: int = 2:
	set(_v):
		size = _v
		_update_area()
@export var side: SIDE = SIDE.LEFT:
	set(_v):
		side = _v
		_update_area()
@export var snap_to_grid: bool = false:
	set(_v):
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return

	monitoring = false
	_place_player()
	await LevelManager.level_loaded
	monitoring = true
	body_entered.connect(_player_entered)
	
#called when player enters this transition
func _player_entered(_p: Node2D) -> void:
	if not monitoring:
		return
	set_deferred("monitoring", false)  
	LevelManager.load_new_level(level, target_transition_area, Vector2.ZERO)

#places the player at the transition in the new level
func _place_player() -> void:
	if not is_instance_valid(PlayerManager.player):
		return
	if name != LevelManager.target_transition:
		return

	var new_position = global_position
	
	#move player outside the transition box to prevent retrigger
	
	match side:
		SIDE.LEFT:   new_position += Vector2(-48, -24)
		SIDE.RIGHT:  new_position += Vector2(48, 24)
		SIDE.TOP:    new_position += Vector2(-48, 24)
		SIDE.BOTTOM: new_position += Vector2(48, -24)

	PlayerManager.set_player_position(new_position)

#find the TileMapLayer (your floor layer)
func find_tilemaplayer(node: Node) -> TileMapLayer:
	if node is TileMapLayer:
		return node
	for child in node.get_children():
		var found = find_tilemaplayer(child)
		if found != null:
			return found
	return null

func _update_area() -> void:
	var new_rect: Vector2 = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO

	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16

	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")

	collision_shape.shape.size = new_rect
	collision_shape.position = new_position


func _snap_to_grid() -> void:
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16
