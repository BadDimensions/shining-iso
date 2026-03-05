class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction : Vector2)
signal enemy_damaged
signal enemy_destroyed

const DIR_8 = [
	Vector2(1, 0),    # right
	Vector2(1, 1),    # down-right
	Vector2(0, 1),    # down
	Vector2(-1, 1),   # down-left
	Vector2(-1, 0),   # left
	Vector2(-1, -1),  # up-left
	Vector2(0, -1),   # up
	Vector2(1, -1)    # up-right
]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var last_direction: Vector2 = Vector2.DOWN
var player : Player
var invulnerable : bool = false
var direction : Vector2 = Vector2.ZERO:
	set(new_direction):
		direction = new_direction
		UpdateFacing(new_direction)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var enemy_state_machine: Node = $EnemyStateMachine



func _ready() -> void:
	enemy_state_machine.Initialize(self)
	player = PlayerManager.player
	hitbox.Damaged.connect(_take_damage)
	pass # Replace with function body.



func _physics_process(_delta):
	move_and_slide()


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


func UpdateAnimation(state : String) -> void:
	animation_player.play( state + "_" + AnimDirection(direction))

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


func _take_damage( damage : int) -> void:
	if invulnerable == true:
		return
	hp -= damage
	if hp > 0:
		enemy_damaged.emit()
	else:
		enemy_destroyed.emit()
