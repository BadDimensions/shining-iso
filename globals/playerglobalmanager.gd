extends Node

const INVENTORY_DATA : InventoryData = preload("res://GUI/PauseMenu/inventory/player_inventory.tres")

signal interact_pressed

var player : Player
var hp: int = 3
var max_hp: int = 3
var last_direction: Vector2 = Vector2.DOWN
var player_position: Vector2 = Vector2.ZERO
var is_loading: bool = false
