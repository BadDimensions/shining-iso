class_name EnemyStateChase extends EnemyState

@export var anim_name : String = "walk"
@export var chase_speed : float = 20.0
@export var vision_area : VisionArea
@export var attack_area : Area2D
@export var turn_rate : float = 0.25
@export_category ("AI")
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState
@export var attack_state : EnemyState

var _can_see_player : bool = false
var timer : float = 0.0
var direction : Vector2

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)
	pass
	
func _ready():
	pass # Replace with function body.

func Enter() -> void:
	timer = state_aggro_duration
	enemy.UpdateAnimation(anim_name)
	if attack_area:
		attack_area.monitoring = true
	pass

func Exit() -> void:
	if attack_area:
		attack_area.monitoring = false
		_can_see_player = false
	pass

func Process(_delta: float) -> EnemyState:
	# use attack_area.has_overlapping_areas() instead of has_overlapping_bodies()
	if attack_area and attack_area.has_overlapping_areas():
		#stop the enemy before changing states to prevent tethering behavior
		enemy.velocity = Vector2.ZERO
		return attack_state
	
	var new_dir : Vector2 = enemy.global_position.direction_to(PlayerManager.player.global_position)
	direction = lerp(direction, new_dir, turn_rate)
	enemy.velocity = direction * chase_speed
	enemy.direction = direction
	enemy.UpdateAnimation(anim_name)
		
	if _can_see_player == false:
		timer -= _delta
		if timer < 0:
			return next_state
	else:
		timer = state_aggro_duration
	return null
			
func Physics(_delta: float) -> EnemyState:
	return null
	
func _on_player_enter() -> void:
	_can_see_player = true
	if state_machine.current_state is EnemyStateStun:
		return
	if state_machine.current_state is EnemyStateAttack:
		return
	state_machine.ChangeState(self)
	pass
	
func _on_player_exit() -> void:
	_can_see_player = false
	pass
