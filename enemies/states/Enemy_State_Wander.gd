class_name EnemyStateWander extends EnemyState

@export var anim_name : String = "walk"
@export var wander_speed : float = 20.0

@export_category ("AI")
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState

var timer : float = 0.0
var direction : Vector2

func init() -> void:
	pass
	
func _ready():
	pass # Replace with function body.

func Enter() -> void:
	timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	direction = enemy.DIR_8.pick_random().normalized()
	enemy.SetDirection()
	enemy.velocity = direction * wander_speed
	enemy.UpdateAnimation(anim_name)
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	timer -= _delta
	if timer < 0:
		return next_state
	return null

func Physics(delta: float) -> EnemyState:
	enemy.velocity = direction * wander_speed
	enemy.SetDirection()
	enemy.UpdateAnimation(anim_name) 
	return null
	
