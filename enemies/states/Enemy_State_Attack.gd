class_name EnemyStateAttack extends EnemyState


@export var anim_name : String = "attack"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_hurtbox: Hurtbox = $"../../Sprite2D/AttackHurtbox"
@export_range(1.20,0.5) var decelerate_speed: float = 5.0
@export_category ("AI")
@export var state_chase : EnemyState
@export var state_fallback : EnemyState  
@export var vision_area : VisionArea
@export var attack_cooldown: float = 1.0 
var attack_timer: float = 0.0
var attacking : bool = false
var _can_see_player : bool = false

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)

func _ready() -> void:
	if not animation_player.animation_finished.is_connected(EndAttack):
		animation_player.animation_finished.connect(EndAttack)
	pass
	

func Enter() -> void:
	if attacking or attack_timer > 0:
		return
	enemy.UpdateAnimation(anim_name)
	enemy.direction = enemy.direction
	attacking = true
	attack_hurtbox.monitoring = true
	
func Exit() -> void:
	attacking = false
	attack_hurtbox.monitoring = false
	pass
	
func Process(_delta: float) -> EnemyState:
	if not enemy or not enemy.player:
		return null
	if attack_timer > 0:
		attack_timer -= _delta
	if attacking:
		return null
	elif _can_see_player:
		return state_chase
	else:
		return state_fallback


func Physics(_delta: float) -> EnemyState:
	return null

func _on_player_enter() -> void:
	_can_see_player = true

func _on_player_exit() -> void:
	_can_see_player = false

func EndAttack(_newAnimName: String) -> void:
	print("EndAttack called for: ", _newAnimName)
	attacking = false
	attack_hurtbox.monitoring = false
	attack_timer = attack_cooldown 
