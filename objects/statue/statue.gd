class_name Pushable extends RigidBody2D

@export var push_speed : float = 30.0

var push_direction : Vector2 = Vector2.ZERO : set = _set_push


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta:float) -> void:
	linear_velocity = push_direction * push_speed
	pass
	
func _set_push(value:Vector2) -> void:
	push_direction = value
	pass
