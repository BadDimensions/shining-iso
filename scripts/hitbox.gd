class_name Hitbox extends Area2D

signal Damaged (hurtbox : Hurtbox)

func _ready() -> void:
	pass 

func TakeDamage(hurt_box : Hurtbox) -> void:
	Damaged.emit(hurt_box)
