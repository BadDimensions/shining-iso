class_name Level extends Node2D

@export var music : AudioStream
#@export var boss: CharacterBody2D
#@onready var position_markers: Node2D = $Actors/PositionMarkers


func _ready() -> void:
	AudioManager.play_music(music)
	pass

func resume_music():
	AudioManager.play_music(music)
