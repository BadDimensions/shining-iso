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
const move_speed = 20
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

@export var is_invincible = false
@export var max_hp : int = 10
var hp : int = 10
@export var chase_speed : float = 20.0
@export var state_aggro_duration : float = 0.5
var _can_see_player : bool = false
@export var melee_range = 40.0
@export var attack_cooldown: float = 1.0
var is_teleporting := false
var is_dying := false
var is_busy = false
var orb_ready = true
var player : Player
var teleport_positions: Array[Vector2] = []
@export var melee_cooldown := 1.0
@export var orb_cooldown := 20.0
@export var teleport_invulnerability := 0.5
var cardinal_direction : Vector2 = Vector2.DOWN
var last_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vision_area: VisionArea = $VisionArea
@onready var attack_hurtbox: Hurtbox = $Sprite2D/AttackHurtbox
@onready var melee_timer: Timer = $MeleeTimer


func _ready():
	#player = get_tree().get_first_node_in_group("player")
	#change_state(STATE.IDLE)
	UpdateAnimation("idle")
	hitbox.Damaged.connect(take_damage)

func _process(delta:float) -> void:
	pass
	
func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	if state == STATE.WALK:
		var dist = global_position.distance_to(player.global_position)
		if dist <= melee_range and melee_timer.is_stopped():
			change_state(STATE.ATTACK)
		if orb_ready and randf() < 0.01:
			change_state(STATE.CAST)
			start_orb_cooldown()
	match state:
		STATE.IDLE:
			velocity = Vector2.ZERO

		STATE.WALK:
			chase()

		STATE.ATTACK:
			velocity = Vector2.ZERO

		STATE.CAST:
			velocity = Vector2.ZERO

		STATE.TELEPORT:
			velocity = Vector2.ZERO

	move_and_slide()
	


func change_state(new_state):
	if is_dying:
		return
	if is_teleporting:
		return
	if state == new_state:
		return

	state = new_state

	match state:
		STATE.IDLE:
			UpdateAnimation("idle")

		STATE.WALK:
			UpdateAnimation("walk")

		STATE.ATTACK:
			start_melee_attack()

		STATE.CAST:
			start_orb_attack()

		STATE.TELEPORT:
			start_teleport()

		STATE.DESTROY:
			destroy()
		
		
func start_melee_attack():
	velocity = Vector2.ZERO
	melee_attack()
	
func start_orb_attack():
	velocity = Vector2.ZERO
	orb_attack()
	
func start_teleport():
	velocity = Vector2.ZERO
	teleport()
	
func destroy():
	if is_dying:
		return

	is_dying = true
	state = STATE.DESTROY
	is_invincible = true
	velocity = Vector2.ZERO
	enemy_destroyed.emit()
	animation_player.play("destroy")
	AudioManager.stop_music()
	
	await animation_player.animation_finished

	queue_free()
	
		
func chase():
	if player == null:
		return

	direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed

	UpdateFacing(direction)
	
func melee_attack():
	velocity = Vector2.ZERO
	UpdateAnimation("attack")
	await animation_player.animation_finished
	if state != STATE.ATTACK:
		return
	melee_timer.start(attack_cooldown) 
	change_state(STATE.WALK)
		
func teleport():
	is_teleporting = true
	is_busy = true
	is_invincible = true

	velocity = Vector2.ZERO
	animation_player.play("RESET")
	animation_player.play("disappear")
	await animation_player.animation_finished

	# safety check (important)
	if teleport_positions.is_empty():
		is_teleporting = false
		is_busy = false
		is_invincible = false
		return

	global_position = teleport_positions.pick_random()

	animation_player.play("reappear")
	await animation_player.animation_finished

	is_busy = false
	is_invincible = false
	is_teleporting = false

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
	orb.set_direction(global_position.direction_to(player.global_position))
	change_state(STATE.WALK)

func start_orb_cooldown():
	orb_ready = false
	await get_tree().create_timer(orb_cooldown).timeout
	orb_ready = true
	
func take_damage(hurt_box : Hurtbox) -> void:
	enemy_damaged.emit()
	if is_invincible:
		return
	if is_dying:
		return
	hp -= hurt_box.damage
	HealthGui.update_boss_health(hp,max_hp)
	PlayerManager.shake_camera(hurt_box.damage)
	if hp <= 0:
		change_state(STATE.DESTROY)
		return
	
	deferred_damage.call_deferred()	
	#interrupt_actions()

	#change_state(STATE.TELEPORT)
func deferred_damage():
	interrupt_actions()
	change_state(STATE.TELEPORT)

func interrupt_actions():
	
	animation_player.stop()
	velocity = Vector2.ZERO
		
func UpdateFacing(new_direction: Vector2) -> void:
	if new_direction.length() < 0.1:
		last_direction = new_direction
		#return
	direction = new_direction
	#last_direction = new_direction

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

	vision_area.rotation_degrees = cardinal_direction_to_degrees(cardinal_direction)

	UpdateAnimation("walk")
func cardinal_direction_to_degrees(dir: Vector2) -> float:
	if dir == Vector2.DOWN:
		return 0
	elif dir == Vector2.UP:
		return 180
	elif dir == Vector2.LEFT:
		return 90
	elif dir == Vector2.RIGHT:
		return -90
	return 0
			
func UpdateAnimation(state : String) -> void:
	animation_player.play( state + "_" + AnimDirection(direction))

func AnimDirection(dir: Vector2) -> String:
	if dir.length() < 0.1:
		#dir = last_direction
		return "down"
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
