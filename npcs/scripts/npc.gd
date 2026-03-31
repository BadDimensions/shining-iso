@tool
class_name NPC extends CharacterBody2D

signal behavior_enabled
signal direction_changed(new_direction : Vector2)

@export var npc_resource : NPCResource : set = _set_npc_resource
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var state : String = "idle"
var cardinal_direction : Vector2 = Vector2.DOWN
var last_direction : Vector2 = Vector2.DOWN
var do_behavior : bool = false
var direction : Vector2 = Vector2.ZERO:
	set(new_direction):
		direction = new_direction
		UpdateFacing(new_direction)


func _ready() -> void:
	setup_npc()
	if Engine.is_editor_hint():
		return
	do_behavior = true
	await get_tree().process_frame
	behavior_enabled.emit()
	print("behavior")

func _physics_process(delta : float) -> void:
	move_and_slide()

func UpdateAnimation(state: String) -> void:
	var anim_dir := last_direction
	var anim_name := state + "_" + AnimDirection(anim_dir)
	animation_player.play(state + "_" + AnimDirection(direction))
	
func AnimDirection(dir: Vector2) -> String:
	if dir.length() < 0.1:
		dir = last_direction

	if dir.y < 0 and abs(dir.x) < 0.5:
		return "up"
	elif dir.y > 0 and abs(dir.x) < 0.5:
		return "down"
	elif dir.y < 0:
		return "diagonal_up"
	elif dir.y > 0:
		return "diagonal_down"
	else:
		return "side"

func UpdateFacing(new_direction: Vector2) -> void:
	if new_direction.length() < 0.1:
		return

	last_direction = new_direction

	# Flip only for side animation
	if new_direction.x != 0:
		sprite_2d.scale.x = -1 if new_direction.x < 0 else 1
	else:
		sprite_2d.scale.x = 1

	# Calculate the new cardinal direction
	var new_cardinal : Vector2
	if abs(new_direction.x) > abs(new_direction.y):
		new_cardinal = Vector2.RIGHT if new_direction.x > 0 else Vector2.LEFT
	else:
		new_cardinal = Vector2.DOWN if new_direction.y > 0 else Vector2.UP

	# 2. Only update and emit the signal if direction is changed
	if new_cardinal != cardinal_direction:
		cardinal_direction = new_cardinal
		direction_changed.emit(cardinal_direction)
	
	
func setup_npc() -> void:
	if npc_resource and sprite_2d:
		if sprite_2d:
			sprite_2d.texture = npc_resource.sprite


func _set_npc_resource(_npc : NPCResource) -> void:
	npc_resource = _npc
	setup_npc()
