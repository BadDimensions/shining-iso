extends CanvasLayer

# NOTE - it seems like this file autoloads,
# it boots before the level or player exist
# trying to fetch player in _ready would return undefined
@onready var game_over: Control = $GameOver
@onready var continue_button: Button = $GameOver/VBoxContainer/continue_button
@onready var title_button: Button = $GameOver/VBoxContainer/title_button
@onready var animation_player: AnimationPlayer = $GameOver/AnimationPlayer


@onready var sprite_2d: Sprite2D = $Sprite2D

var frame : Array = [ "frame_zero", "frame_one", "frame_two", "frame_three"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# wait for the level loaded signal, then connect _on_level_loaded
	LevelManager.level_loaded.connect(_on_level_loaded)
	hide_game_over_screen()
	continue_button.pressed.connect(load_game)
	title_button.pressed.connect(title_screen)
	LevelManager.level_load_started.connect(hide_game_over_screen)
	
func _on_level_loaded () -> void:
	# now player should be available
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_signal("health_changed"):
		player.health_changed.connect(_on_health_changed)
		update_health_display(player.hp, player.max_hp)

func update_health_display(current_hp: int, max_hp: int) -> void:
	var hearts_empty = max_hp - current_hp
	sprite_2d.frame = hearts_empty


func _on_health_changed(current_hp: int, max_hp: int) -> void:
	update_health_display(current_hp, max_hp)

func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = Globalsavemanager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	
	if can_continue == true:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()
		
func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1,1,1,0)
	

func load_game() -> void:
	await fade_to_black()
	Globalsavemanager.load_game()

func title_screen() -> void:
	await fade_to_black()
	LevelManager.load_new_level("res://title_screen/title_screen.tscn", "", Vector2.ZERO)

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	
	await animation_player.animation_finished
	PlayerManager.player.revive_player()	
	return true	
	
#func play_audio(_a : AudioStream) -> void:
	#audio_stream = _a
	#audio.play()
