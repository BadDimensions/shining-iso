class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN

var direction : Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D

signal DirectionChanged (new_direction: Vector2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	pass # Replace with function body.

func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction.length() >= 0.1:
		last_direction = direction
	#direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	SetDirection()
	pass

func _physics_process(delta : float) -> void:
	if state_machine.current_state:
		state_machine.ChangeState(state_machine.current_state.Physics(delta))
	move_and_slide()
	
#func SetDirection() -> bool:
	#var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))	
	#var new_dir = DIR_4 [ direction_id ]
	
	#if new_dir == cardinal_direction:
		#return false
		
	#cardinal_direction = new_dir
	#DirectionChanged.emit(new_dir)
	#sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	#return true
func SetDirection() -> void:
	if direction.length() < 0.1:
		return

	var anim_dir = AnimDirection()

	# Flip only for side animation
	if direction.x != 0:
		sprite_2d.scale.x = -1 if direction.x < 0 else 1
	else:
		sprite_2d.scale.x = 1
	# Update cardinal direction (if you still need it)
	if abs(direction.x) > abs(direction.y):
		cardinal_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		cardinal_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP

	DirectionChanged.emit(cardinal_direction)
func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	return Vector2(cartesian.x - cartesian.y,(cartesian.x + cartesian.y) / 2)

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	
func AnimDirection() -> String:
	var dir = direction
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
	
