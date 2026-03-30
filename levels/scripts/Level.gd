class_name Level extends Node2D

@export var music : AudioStream

func _ready() -> void:
	AudioManager.play_music(music)
	pass
