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
	#player.velocity = player.direction * move_speed
		
	player.SetDirection()
	player.UpdateAnimation("kurt_walk")
	return null

func Physics(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		var iso_dir = player.cartesian_to_isometric(player.direction).normalized()
		#var iso_direction = Vector2(player.direction.x - player.direction.y,(player.direction.x + player.direction.y)/2).normalized()
		player.velocity = iso_dir * move_speed
	else:
		player.velocity = Vector2.ZERO
	#player.SetDirection()
	player.move_and_slide()
	return null
	

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return state_attack	
	return null
