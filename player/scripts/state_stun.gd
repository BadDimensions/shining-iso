class_name State_Stun extends State


@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : Hurtbox
var direction : Vector2
var next_state : State = null

@onready var state_idle: State_Idle = $"../StateIdle"
@onready var state_death: State_Death = $"../StateDeath"


func init() -> void:
	player.player_damaged.connect(_player_damaged)
	

func Enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	direction = hurt_box.global_position.direction_to(player.global_position)
	player.velocity = direction * knockback_speed
	player.UpdateFacing(direction)
	player.UpdateAnimation("kurt_hit")
	player.make_invulnerable(invulnerable_duration)
	player.effects_animation_player.play("damaged")
	pass

func Exit() -> void:
	next_state	= null
	player.animation_player.animation_finished.disconnect(_animation_finished)

func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null

func _player_damaged(_hurt_box : Hurtbox) -> void:
	hurt_box = _hurt_box
	if state_machine.current_state != state_death:
		state_machine.ChangeState(self)
	pass
	
func _animation_finished(_a : String) -> void:
	next_state = state_idle	
	if player.hp <= 0:
		next_state = state_death
