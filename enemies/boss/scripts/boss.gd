class_name KnightBoss extends CharacterBody2D

enum STATE {
	IDLE,
	WALK,
	ATTACK,
	CAST,
	TELEPORT,
	DESTROY
}
var state = STATE.IDLE
signal direction_changed(new_direction : Vector2)
signal enemy_damaged
signal enemy_destroyed

const ENEMY_PROJECTILE : PackedScene = preload("res://enemies/boss/enemy_projectile01.tscn")
const move_speed = 120
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

@export var acceleration = 200
@export var friction = 10000
@export var is_invincible = false
@export var max_hp : int = 10
var hp : int = 10
@export var attack_range: float = 100.0
@export var chase_speed : float = 20.0
@export var state_aggro_duration : float = 0.5
var _can_see_player : bool = false
@export var melee_range = 40.0
@export var attack_cooldown: float = 1.0
var is_busy = false
var orb_ready = true
var can_attack = true
var player : Player
var invulnerable : bool = false
var teleport_positions: Array[Vector2] = []
@export var melee_cooldown := 1.0
@export var orb_cooldown := 4.0
@export var teleport_invulnerability := 0.5
var cardinal_direction : Vector2 = Vector2.DOWN
var last_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vision_area: VisionArea = $VisionArea


func _ready():
	player = get_tree().get_first_node_in_group("player")
	change_state(STATE.WALK)
	hitbox.Damaged.connect(take_damage)
	
	
func _physics_process(delta):
	if state == STATE.WALK and player:
		var dist = global_position.distance_to(player.global_position)
		if dist <= melee_range and can_attack:
			change_state(STATE.ATTACK)
	
	match state:

		STATE.IDLE:
			velocity = Vector2.ZERO
			
		STATE.WALK:
			_can_see_player = true
			chase()
			
		STATE.ATTACK:
			velocity = Vector2.ZERO

		STATE.CAST:
			velocity = Vector2.ZERO

		STATE.TELEPORT:
			velocity = Vector2.ZERO
	
	
	move_and_slide()
	
func change_state(new_state):

	if state == new_state:
		return

	if state in [STATE.ATTACK, STATE.CAST, STATE.TELEPORT]:
		if new_state != STATE.WALK and new_state != STATE.DESTROY:
			return

	state = new_state

	match state:

		STATE.IDLE:
			UpdateAnimation("idle")

		STATE.WALK:
			UpdateAnimation("walk")

		STATE.ATTACK:
			melee_attack()

		STATE.TELEPORT:
			teleport()

		STATE.CAST:
			orb_attack()

		STATE.DESTROY:
			velocity = Vector2.ZERO
			animation_player.play("destroy")
			await animation_player.animation_finished
			queue_free()
		
		

func chase():
	if player == null:
		return

	direction = (player.global_position - global_position).normalized()

	velocity = direction * move_speed

	UpdateFacing(direction)

func melee_attack():

	can_attack = false

	velocity = Vector2.ZERO

	UpdateAnimation("attack")

	await animation_player.animation_finished

	if state != STATE.ATTACK:
		return

	await get_tree().create_timer(attack_cooldown).timeout

	can_attack = true

	change_state(STATE.WALK)
			
func teleport():
	if is_busy:
		return
	velocity = Vector2.ZERO	
	is_busy = true
	animation_player.play("disappear")

	await animation_player.animation_finished
	
	if teleport_positions.is_empty():
		is_busy = false
		return
	global_position = teleport_positions.pick_random()
	
	animation_player.play("reappear")

	await animation_player.animation_finished
	
	is_busy = false
	change_state(STATE.WALK)

func set_teleport_positions(points: Array[Vector2]) -> void:
	teleport_positions = points			

func orb_attack():

	orb_ready = false

	animation_player.play("orb_attack")

	await animation_player.animation_finished

	if state != STATE.CAST:
		return

	var orb = ENEMY_PROJECTILE.instantiate()
	get_parent().add_child(orb)
	orb.global_position = global_position

	await get_tree().create_timer(orb_cooldown).timeout
	orb_ready = true

	change_state(STATE.WALK)


	
func take_damage(hurt_box : Hurtbox) -> void:

	if is_invincible:
		return

	hp -= hurt_box.damage
	PlayerManager.shake_camera(hurt_box.damage)
	if hp <= 0:
		change_state(STATE.DESTROY)
		return
	if is_busy:
		return
		
	interrupt_actions()

	change_state(STATE.TELEPORT)

func interrupt_actions():

	animation_player.stop()
	velocity = Vector2.ZERO
	
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

func busy() -> bool:
	return state in [
		STATE.ATTACK,
		STATE.CAST,
		STATE.TELEPORT,
		STATE.DESTROY
	]
