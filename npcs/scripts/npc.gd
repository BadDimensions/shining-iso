@tool
class_name NPC extends CharacterBody2D

signal behavior_enabled

@export var npc_resource : NPCResource : set = _set_npc_resource
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction : Vector2 = Vector2.DOWN
var last_direction : Vector2 = Vector2.DOWN
var do_behavior : bool = false

func _ready() -> void:
	setup_npc()
	if Engine.is_editor_hint():
		return
	behavior_enabled.emit()


func _physics_process(delta : float) -> void:
	move_and_slide()


func update_direction(target_position : Vector2) -> void:
	direction = global_position.direction_to(target_position)
	

func UpdateAnimation(state : String) -> void:
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

	
	
func setup_npc() -> void:
	if npc_resource and sprite_2d:
		sprite_2d.texture = npc_resource.sprite


func _set_npc_resource(_npc : NPCResource) -> void:
	npc_resource = _npc
	setup_npc()
