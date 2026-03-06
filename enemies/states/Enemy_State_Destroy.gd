class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category ("AI")

var direction : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect(on_enemy_destroyed)
	# Connect animation_finished once here
	enemy.animation_player.animation_finished.connect(on_animation_finished)

func Enter() -> void:
	enemy.invulnerable = true
	direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.UpdateFacing(direction)
	enemy.velocity = direction * -knockback_speed
	enemy.UpdateAnimation(anim_name)

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics(_delta: float) -> EnemyState:
	return null

#func on_enemy_destroyed() -> void:
	#state_machine.ChangeState(self)
	#pass
func on_enemy_destroyed() -> void:
	# Only change state if not already in Destroy
	if state_machine.current_state != self:
		state_machine.ChangeState(self)

func on_animation_finished(finished_anim: String) -> void:
	print("Animation finished:", finished_anim)
	if finished_anim == anim_name:
		enemy.queue_free()
 		
