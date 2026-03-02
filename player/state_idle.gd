class_name State_Idle extends State

@onready var state_walk: State_Walk = $"../StateWalk"
@onready var state_attack: State_Attack = $"../StateAttack"

func Enter() -> void:
	player.UpdateAnimation("kurt_idle")
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return state_walk
	player.velocity = Vector2.ZERO
	return null
	
func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return state_attack 
	return null
