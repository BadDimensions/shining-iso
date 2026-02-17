class_name State_Walk extends State

@export var move_speed: float = 50.0

@onready var state_idle: State_Idle = $"../StateIdle"
@onready var state_attack: State_Attack = $"../StateAttack"

# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass

func Exit() -> void:
	pass
	
func Process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return state_idle
		
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null
func Physics(_delta: float) -> State:
	return null	

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return state_attack	
	return null
