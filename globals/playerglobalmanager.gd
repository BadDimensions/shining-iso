extends Node

const INVENTORY_DATA : InventoryData = preload("res://GUI/PauseMenu/inventory/player_inventory.tres")

signal interact_pressed
signal camera_shook(trauma : float)

var player : Player
var hp: int = 3:
	set(value):
		hp = clampi(value, 0, max_hp)
	get:
		return hp

var max_hp: int = 3

var last_direction: Vector2 = Vector2.DOWN

var player_position: Vector2 = Vector2.ZERO
		
var is_loading: bool = false

func shake_camera(trauma : float) -> void:
	camera_shook.emit(trauma)
	pass
