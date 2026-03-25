@tool
class_name Chest extends Node2D

@export var item_data: ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity
@onready var sprite: Sprite2D = $Sprite2D2
@onready var label: Label = $Sprite2D2/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var is_open_data: PersistentDataHandler = $IsOpenData

var is_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_texture()
	_update_label()
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect(_on_area_enter)
	interact_area.area_exited.connect(_on_area_exit)
	is_open_data.data_loaded.connect(set_chest_state)
	set_chest_state()
	pass # Replace with function body.

func player_interact() -> void:
	if is_open == true:
		return
	is_open == true
	is_open_data.set_value()
	animation_player.play("opening")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)
	else:
		printerr("No Item in Chest")
	pass
	
func _on_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	pass
	
func _on_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)
	pass	

func _set_item_data(value : ItemData) -> void:
	item_data = value
	_update_texture()
	pass
	
func _set_quantity(value : int) -> void:
	quantity = value
	_update_label()
	pass	
	
func _update_texture() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texture
		
func _update_label() -> void:
	if label:
		if quantity < 1:
			label.text = ""
		else:
			label.text ="x" + str(quantity)	

func set_chest_state() -> void:
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
