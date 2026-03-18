extends CanvasLayer

# NOTE - it seems like this file autoloads,
# it boots before the level or player exist
# trying to fetch player in _ready would return undefined

@onready var sprite_2d: Sprite2D = $Sprite2D

var frame : Array = [ "frame_zero", "frame_one", "frame_two", "frame_three"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# wait for the level loaded signal, then connect _on_level_loaded
	LevelManager.level_loaded.connect(_on_level_loaded)

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
