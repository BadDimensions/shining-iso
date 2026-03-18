extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved
var current_save : Dictionary = {
	scene_path = "",
	player ={
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
	},
	items = [],
	persistence = [],
	quests = []
}

func save_game() -> void:
	update_player_data()
	update_scene_path()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	pass
	
func load_game() -> void:
	print("load game")
	PlayerManager.is_loading = true

	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	await LevelManager.level_load_started
	
	
	PlayerManager.player_position = Vector2(current_save.player.pos_x,current_save.player.pos_y)

	PlayerManager.hp = current_save.player.hp
	PlayerManager.max_hp = current_save.player.max_hp
	
	await LevelManager.level_loaded
	
	while PlayerManager.player == null:
		await get_tree().process_frame
		
	if PlayerManager.player:
		var player = PlayerManager.player
		player.global_position = PlayerManager.player_position
		player.hp = PlayerManager.hp
		player.max_hp = PlayerManager.max_hp
		player.emit_signal("health_changed", player.hp, player.max_hp)
	
	game_loaded.emit()
	PlayerManager.is_loading = false
	

func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	
func update_scene_path() -> void:
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p= c.scene_file_path
	current_save.scene_path = p
