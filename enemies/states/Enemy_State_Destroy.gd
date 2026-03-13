class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category ("AI")
var _damage_position : Vector2
var direction : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect(on_enemy_destroyed)
	# Connect animation_finished once here
	enemy.animation_player.animation_finished.connect(on_animation_finished)

func Enter() -> void:
	enemy.invulnerable = true
	direction = enemy.global_position.direction_to(_damage_position)
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
func on_enemy_destroyed(hurt_box : Hurtbox) -> void:
	_damage_position = hurt_box.global_position
	# Only change state if not already in Destroy
	if state_machine.current_state != self:
		state_machine.ChangeState(self)

func on_animation_finished(finished_anim: String) -> void:
	print("Animation finished:", finished_anim)
#	
	# if finished_anim.begins_with(anim_name):
	# This isn't triggering since in the gorblin script, we play anim like `animation_player.play(state + "_" + AnimDirection(direction))`
	# The finished_anim is like "destroy_up", "destroy_down", etc
	# But we're checking for a match of `finished_anim == "destroy"`, which never comes, it's always prepended with a direction
	
	# Check if the animation name starts with our state's base name (e.g., "destroy")
	if finished_anim.begins_with(anim_name):
		enemy.queue_free()
 		
