class_name NPCResource extends Resource

@export var npc_name : String = ""
@export var sprite : Texture
@export var portrait : Texture
@export_range(0.5, 1.8, 0.02) var dialogue_audio_pitch: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
