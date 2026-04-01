class_name PlayerInteractionHost extends Node2D

@onready var player: Player = $".."



func _ready() -> void:
	player.DirectionChanged.connect(UpdateDirection)
	pass 

func UpdateDirection(new_direction: Vector2) -> void:
	if new_direction == Vector2.ZERO:
		return
	
	rotation = new_direction.angle() + deg_to_rad(-90)
