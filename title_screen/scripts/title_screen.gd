extends Node

const START_LEVEL : String = "res://levels/area1/01.tscn"

@onready var new_game_button: Button = $CanvasLayer/Control/NewGame_Button
@onready var continue_button: Button = $CanvasLayer/Control/Continue_Button
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@export var music: AudioStream

func _ready() -> void:
	get_tree().paused = true
	#PlayerManager.player.visible = false
	HealthGui.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	if Globalsavemanager.get_save_file == null:
		continue_button.disabled = true
		continue_button.disabled = false
	
	$CanvasLayer/SplashScreen.finished.connect(setup_title_screen)
	
	LevelManager.level_load_started.connect(exit_title_screen)
	
func setup_title_screen() -> void:
	AudioManager.play_music(music)
	new_game_button.pressed.connect(start_game)
	continue_button.pressed.connect(load_game)
	new_game_button.grab_focus()
		
	pass 

func start_game() -> void:
	LevelManager.load_new_level(START_LEVEL,"",Vector2.ZERO)
	pass
	
func load_game() -> void:
	Globalsavemanager.load_game()
	pass
	
func exit_title_screen() -> void:
	#PlayerManager.player.visible = true
	HealthGui.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	pass
	
func play_audio(_a : AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
	
