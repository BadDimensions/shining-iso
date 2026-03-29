class_name LockedDoor extends Node2D

var is_open : bool = false
@export var required_item: ItemData 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area : Area2D = $Area2D
@onready var is_open_data: PersistentDataHandler = $IsOpenData


func _ready() -> void:
	interact_area.area_entered.connect(_on_area_enter)
	interact_area.area_exited.connect(_on_area_exit)
	is_open_data.data_loaded.connect(set_door_state)
	set_door_state()
	pass 

func player_interact() -> void:
	if is_open == true:
		return
	open_door()
	pass

func _on_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	pass
	
func _on_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)
	pass	

func open_door() -> void:
	if is_open:
		return
	if PlayerManager.INVENTORY_DATA.has_item(required_item):
		is_open = true
		animation_player.play("opening")
		is_open_data.set_value()
	else:
		print("Door is locked")


func set_door_state() -> void:
	is_open = is_open_data.value
	
	if is_open:
		animation_player.play("open")
		animation_player.seek(0, true) 
	else:
		animation_player.play("closed")
		animation_player.seek(0, true)
