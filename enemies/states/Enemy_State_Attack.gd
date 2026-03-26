class_name EnemyStateAttack extends EnemyState

@export var anim_name : String = "attack"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_hurtbox: Hurtbox = $"../../Sprite2D/AttackHurtbox"
@export_range(1.20,0.5) var decelerate_speed: float = 5.0
@export_category ("AI")
@export var state_chase : EnemyState
@export var state_fallback : EnemyState  
@export var vision_area : VisionArea
var attacking : bool = false
var _can_see_player : bool = false

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)

func _ready() -> void:
	pass
	

func Enter() -> void:
	enemy.direction = enemy.direction
	enemy.UpdateAnimation(anim_name)
	attacking = true
	animation_player.animation_finished.connect(EndAttack)
	#attack_hurtbox.monitoring = false
	#var timer = get_tree().create_timer(0.075)
	#timer.timeout.connect(_enable_attack_hitbox)
	pass

func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	attack_hurtbox.monitoring = false
	pass
	

func Process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if _can_see_player == true:
			return state_chase
	else:
			return state_fallback
	return null

func Physics(_delta: float) -> EnemyState:
	return null

func _enable_attack_hitbox(): 
	if attacking:
		attack_hurtbox.monitoring = true	

func _on_player_enter() -> void:
	_can_see_player = true

func _on_player_exit() -> void:
	_can_see_player = false

func EndAttack(_newAnimName: String) -> void:
	attacking = false
