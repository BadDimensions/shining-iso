class_name Player extends CharacterBody2D

signal player_damaged(hurt_box : Hurtbox)
signal health_changed(current_hp: int, max_hp: int)

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO:
	set(new_direction):
		direction = new_direction
		UpdateFacing(new_direction)
var invulnerable : bool = false
var hp : int = 3
var max_hp : int = 3
var last_direction: Vector2 = Vector2.DOWN
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effects_animation_player: AnimationPlayer = $EffectsAnimationPlayer

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: Hitbox = $Hitbox

signal DirectionChanged (new_direction: Vector2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player = self
	global_position = PlayerManager.player_position
	hp = PlayerManager.hp
	max_hp = PlayerManager.max_hp
	last_direction = PlayerManager.last_direction
	state_machine.Initialize(self)
	hit_box.Damaged.connect(_take_damage)
	emit_signal("health_changed", hp, max_hp)


func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()

func _physics_process(delta : float) -> void:
	if state_machine.current_state:
		state_machine.ChangeState(state_machine.current_state.Physics(delta))
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
	# Update cardinal direction (if you still need it)
	if abs(new_direction.x) > abs(new_direction.y):
		cardinal_direction = Vector2.RIGHT if new_direction.x > 0 else Vector2.LEFT
	else:
		cardinal_direction = Vector2.DOWN if new_direction.y > 0 else Vector2.UP

	DirectionChanged.emit(cardinal_direction)

func UpdateAnimation(state: String) -> void:
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

func _take_damage(hurt_box : Hurtbox) -> void:
	if invulnerable == true:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		pass # TODO: state_machine.ChangeState("Death")


func update_hp(_delta: int) -> void:
	hp = clampi(hp + _delta, 0, max_hp)
	emit_signal("health_changed", hp, max_hp)

func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false

	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass

func _exit_tree() -> void:
	PlayerManager.hp = hp
	PlayerManager.max_hp = max_hp
	PlayerManager.last_direction = last_direction
