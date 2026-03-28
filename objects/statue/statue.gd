class_name Pushable extends CharacterBody2D

@export var push_speed: float = 30.0

var push_direction: Vector2 = Vector2.ZERO : set = _set_push


func _physics_process(_delta: float) -> void:
	if push_direction != Vector2.ZERO:
		velocity = push_direction * push_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _set_push(value: Vector2) -> void:
	push_direction = value
