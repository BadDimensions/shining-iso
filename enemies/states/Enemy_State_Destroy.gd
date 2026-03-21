class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://items/item_pickups/item_pickup.tscn")

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category ("AI")
@export_category("Item Drops")
@export var drops : Array[DropData]

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
	drop_items()

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics(_delta: float) -> EnemyState:
	return null


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
 		
func disable_hurtbox() -> void:
	var hurt_box : Hurtbox = enemy.get_node_or_null("Hurtbox")
	if hurt_box:
		hurt_box.monitoring = false

func drop_items() -> void:
	if drops.size() == 0:
		return
	for i in drops.size():
		if drops[i] == null or drops[i] == null:
			continue
		var drop_count : int = drops[i].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position 
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
			pass
