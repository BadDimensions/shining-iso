class_name EnemyStateIdle extends EnemyState

@export var anim_name : String = "idle"
@export_category ("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : EnemyState

var timer : float = 0.0

func init() -> void:
	pass
	
func _ready():
	pass # Replace with function body.

func Enter() -> void:
	enemy.velocity = Vector2.ZERO
	timer = randi_range(state_duration_min, state_duration_max)
	enemy.UpdateAnimation(anim_name)
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	timer -= _delta
	if timer < 0:
		return after_idle_state
	return null

func Physics(_delta: float) -> EnemyState:
	return null
	

	
