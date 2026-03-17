extends Node

const KURT = preload("res://player/kurt.tscn")

var player: Player
var player_spawned : bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance() -> void:
	# get the actors node for whatever level loaded
	var actors = get_tree().current_scene.get_node("Actors")
	
	if not is_instance_valid(player):
		# first boot - instantiate player
		player = KURT.instantiate()
	else:
		# after transition, the player is parked under root
		# (put there by unparent_player during transition)
		# detach from root before we place in new levels Actor node
		var current_parent = player.get_parent()
		if current_parent:
			current_parent.remove_child(player)
	
	# player has no parent, we can safely add to level node
	actors.add_child(player)


#func add_player_instance() -> void:
	#player = KURT.instantiate()
	#var actors = get_tree().get_first_node_in_group("actors")
	#actors.add_child(player)

func set_player_position(_new_pos : Vector2) -> void:
	player.global_position = _new_pos
	pass

func set_as_parent(_p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
		_p.add_child(player)

func unparent_player(_p: Node2D) -> void:
	if not is_instance_valid(player):
		return

	var parent := player.get_parent()
	if parent:
		parent.remove_child(player)

	get_tree().root.add_child(player)


	
