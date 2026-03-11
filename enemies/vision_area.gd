class_name VisionArea extends Area2D

signal player_entered()
signal player_exited()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	pass # Replace with function body.

	var p = get_parent()
	if p is Enemy:
		p.direction_change.connect(_on_direction_change)

func _on_body_entered( _b : Node2D ) -> void:
	if _b is Player:
		player_entered.emit()
	pass
func _on_body_exited( _b : Node2D ) -> void:
	if _b is Player:
		player_exited.emit()
	pass

func _on_direction_change(new_direction : Vector2 ) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_: 
			rotation_degrees = 0
