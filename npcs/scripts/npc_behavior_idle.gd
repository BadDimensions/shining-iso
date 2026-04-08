extends NPCBehavior

@export var idle_min_time : float = 2.0
@export var idle_max_time : float = 4.0
@export var point_chance : float = 0.4
@export var freeze_npc : bool = true

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()
	
	if freeze_npc:
		npc.velocity = Vector2.ZERO
	if npc and not npc.behavior_enabled.is_connected(start):
		npc.behavior_enabled.connect(start)

func start() -> void:
	if npc == null:
		return
	
	while npc.do_behavior:
		# Idle
		npc.state = "idle"
		npc.velocity = Vector2.ZERO
		npc.animation_player.play("idle")
		
		await get_tree().create_timer(randf_range(idle_min_time, idle_max_time)).timeout
		
		if not npc.do_behavior:
			return
		
		# Randomly play "point"
		if randf() < point_chance:
			npc.state = "point"
			npc.animation_player.play("point")
			
			# Wait until the animation finishes
			await npc.animation_player.animation_finished
			
			if not npc.do_behavior:
				return
				
func _physics_process(delta : float) -> void:
	if freeze_npc:
		npc.velocity = Vector2.ZERO
