extends CanvasLayer

@onready var sprite_2d: Sprite2D = $Sprite2D

var frame : Array = [ "frame_zero", "frame_one", "frame_two", "frame_three"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_signal("health_changed"):
		player.health_changed.connect(_on_health_changed)
		
func update_health_display(current_hp: int, max_hp: int) -> void:
	var hearts_empty = max_hp - current_hp
	sprite_2d.frame = hearts_empty  


func _on_health_changed(current_hp: int, max_hp: int) -> void:
	update_health_display(current_hp, max_hp)
	pass
