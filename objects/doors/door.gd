class_name BarredDoor extends Node2D

var is_open : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass 

func open_door() -> void:
	animation_player.play("opening")
	pass
	
func close_door() -> void:
	animation_player.play("closing")
	pass
