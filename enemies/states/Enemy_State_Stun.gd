class_name EnemyStateStun extends EnemyState

@export var anim_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category ("AI")
@export var next_state : EnemyState
var direction : Vector2
var animation_finished : bool = false
var stun_timer : float = 0.0
var stun_duration : float = 0.3

func init() -> void:
	enemy.enemy_damaged.connect(on_enemy_damaged)
	pass


func Enter() -> void:
	stun_timer = 0.0
	enemy.invulnerable = true
	animation_finished = false
	direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.direction = direction
	enemy.velocity = direction * -knockback_speed
	enemy.UpdateAnimation(anim_name)
	#enemy.animation_player.animation_finished.connect(on_animation_finished)
	pass

func Exit() -> void:
	enemy.invulnerable = false
	#enemy.animation_player.animation_finished.connect(on_animation_finished)
	pass

func Process(_delta: float) -> EnemyState:
	stun_timer += _delta
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	if stun_timer >= stun_duration:
		return next_state
	
	return null
	#if animation_finished == true:
		#enemy.velocity -= enemy.velocity * decelerate_speed * _delta
		#return next_state
	#enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	#return null

func Physics(_delta: float) -> EnemyState:
	return null
	
func on_enemy_damaged() -> void:
	state_machine.ChangeState(self)
	

func on_animation_finished(I_a : String) -> void:
	animation_finished = true
