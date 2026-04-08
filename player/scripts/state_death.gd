class_name State_Death extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func init() -> void:
	pass
	
func Enter() -> void:
	animation_player.play("death")
	HealthGui.show_game_over_screen()
	AudioManager.play_music(null)
	player.input_enabled = false
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
