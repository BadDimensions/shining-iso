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
	var new_dir = global_position.direction_to(target_position)
	if new_dir.length() > 0.1:
		direction = new_dir
		last_direction = new_dir
	
	if velocity != Vector2.ZERO:
		UpdateAnimation("walk")
	else:
		UpdateAnimation("idle")


func UpdateAnimation(state : String) -> void:
	var anim_name = state + "_" + AnimDirection(direction)
	
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)

func AnimDirection(dir: Vector2) -> String:
	if dir.length() < 0.1:
		return "down"  

	var angle := rad_to_deg(dir.angle())
	if angle < 0:
		angle += 360

	if angle >= 337.5 or angle < 22.5:
		return "right"
	elif angle < 67.5:
		return "diagonal_down"
	elif angle < 112.5:
		return "down"
	elif angle < 157.5:
		return "diagonal_down"
	elif angle < 202.5:
		return "left"
	elif angle < 247.5:
		return "diagonal_up"
	elif angle < 292.5:
		return "up"
	else:
		return "diagonal_up"
	
func setup_npc() -> void:
	if npc_resource and sprite_2d:
		sprite_2d.texture = npc_resource.sprite


func _set_npc_resource(_npc : NPCResource) -> void:
	npc_resource = _npc
	setup_npc()
