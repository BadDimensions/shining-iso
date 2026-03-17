extends Node2D

const KURT = preload("res://player/kurt.tscn")

func _ready() -> void:
	visible = false

	var player = KURT.instantiate()
	get_parent().get_node("Actors").add_child(player)
	player.global_position = global_position
