extends NPCBehavior

const DIR_8 = [
	Vector2.RIGHT,
	Vector2(1, 1),
	Vector2.DOWN,
	Vector2(-1, 1),
	Vector2.LEFT,
	Vector2(-1, -1),
	Vector2.UP,
	Vector2(1, -1),
]

@export var wander_range : int = 2 : set = _set_wander_range
@export var wander_speed : float = 30.0
@export var wander_duration : float = 1.0
@export var idle_duration : float = 1.0

var original_position : Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()
	$CollisionShape2D.queue_free()
	original_position = npc.global_position

func start() -> void:
	if npc.do_behavior == false:
		return
	
	# Idle
	npc.state = "idle"
	npc.UpdateAnimation(npc.state)
	npc.velocity = Vector2.ZERO
	npc.UpdateFacing(npc.direction)
	await get_tree().create_timer(randf() * idle_duration + idle_duration).timeout
	#if npc.do_behavior == false: #potential bug fix
		#return
	# Walk
	npc.state = "walk"
	var _dir : Vector2 = DIR_8[randi_range(0,7)]
	npc.direction = _dir
	npc.velocity = wander_speed * _dir
	npc.UpdateFacing(npc.direction)
	npc.UpdateAnimation(npc.state)                         
	await get_tree().create_timer(randf() * wander_duration + wander_duration * 0.5).timeout
	
	if npc.do_behavior == false:
		return
	start() 
	pass
	
func _process(delta : float) -> void:
	if Engine.is_editor_hint():
		return
	if abs(global_position.distance_to(original_position)) > wander_range * 32:
		npc.velocity *= -1
		npc.direction *= -1
		npc.UpdateFacing(npc.direction)
		
		

func _set_wander_range(v : int) -> void:
	wander_range = v
	$CollisionShape2D.shape.radius = v * 32
