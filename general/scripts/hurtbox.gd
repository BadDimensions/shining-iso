class_name Hurtbox extends Area2D

signal did_damage

@export var damage: int = 1

func _ready() -> void:
	area_entered.connect(AreaEntered)
	pass 

func AreaEntered(a: Area2D) -> void:
	if a is Hitbox:
		did_damage.emit()
		a.TakeDamage(self)
	pass
