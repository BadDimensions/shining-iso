class_name State_Walk extends State

@export var move_speed: float = 50.0
@onready var state_idle: State_Idle = $"../StateIdle"
@onready var state_attack: State_Attack = $"../StateAttack"

func Enter() -> void:
	player.UpdateAnimation("kurt_walk")
	pass

func Exit() -> void:
	pass
	
func Process(_delta : float) -> State:
	if player.direction.length() < 0.1:
		return state_idle
	
		
	player.SetDirection()
	player.UpdateAnimation("kurt_walk")
	return null

func Physics(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		player.velocity = player.direction * move_speed
	else:
		player.velocity = Vector2.ZERO
	#player.SetDirection()
	player.move_and_slide()
	return null
	

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return state_attack	
	return null
