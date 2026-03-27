class_name PressurePlate extends Node2D

signal activated
signal deactivated

var bodies : int = 0
var is_active : bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	

func _on_body_entered( b : Node2D ) -> void:
	bodies += 1
	check_is_activated()
	animation_player.play("active")
	pass
	
func _on_body_exited( b : Node2D ) -> void:
	bodies -= 1
	check_is_activated()
	animation_player.play("not_active")
	pass
	
func check_is_activated() -> void:
	if bodies > 0 and is_active == false:
		is_active = true
		activated.emit()
	elif bodies == 0 and is_active == true:
		is_active = false
		deactivated.emit()
