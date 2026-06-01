extends Area2D

signal triggered

func _ready():
	#print("Trigger ready")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	#print("Body entered:", body)
	if body is Player:
		triggered.emit()
		set_deferred("monitoring", false)
