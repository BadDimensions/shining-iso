class_name State_Attack extends State

var attacking : bool = false
@onready var state_idle: State_Idle = $"../StateIdle"
@onready var state_walk: State_Walk = $"../StateWalk"

@export_range(1.20,0.5) var decelerate_speed: float = 5.0
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@onready var attack_hurtbox: Hurtbox = $"../../Sprite2D/AttackHurtbox"
# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	player.UpdateAnimation("kurt_attack")
	animation_player.animation_finished.connect(EndAttack)
	attacking = true
	await get_tree().create_timer(0.075).timeout
	attack_hurtbox.monitoring = true
	pass
	
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	attack_hurtbox.monitoring = false
	pass
	
func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return state_idle
		else:
			return state_walk
	return null
	
func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func EndAttack(_newAnimName: String) -> void:
	attacking = false
