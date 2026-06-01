extends Area2D

signal triggered
@export var boss_music: AudioStream
var triggered_once := false

func _ready():
	#print("Trigger ready")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	#print("Body entered:", body)
	if body is Player:
		triggered_once = true
		triggered.emit()
		AudioManager.play_boss_music(boss_music)
		set_deferred("monitoring", false)
