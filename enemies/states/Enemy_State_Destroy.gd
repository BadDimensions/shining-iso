class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category ("AI")

var direction : Vector2
var animation_finished : bool = false

func init() -> void:
	enemy.enemy_destroyed.connect(on_enemy_destroyed)
	pass
	
func _ready():
	pass # Replace with function body.

func Enter() -> void:
	enemy.invulnerable = true
	direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -knockback_speed
	enemy.update_animation(anim_name)
	pass

func Process(_delta: float) -> EnemyState:
	return null

func Physics(_delta: float) -> EnemyState:
	return null
	
func on_enemy_destroyed() -> void:
	state_machine.ChangeState(self)
	
func on_animation_finished():
	enemy.queue_free()
