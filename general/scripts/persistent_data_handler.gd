class_name PersistentDataHandler extends Node

signal data_loaded
var value: bool = false
@export var unique_id: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_value()
	pass # Replace with function body.

func set_value() -> void:
	Globalsavemanager.add_persistent_value(_get_name())
	pass
	
func get_value() -> void:
	value = Globalsavemanager.check_persistent_value(_get_name())
	data_loaded.emit()
	pass
	
func _get_name() -> String:
	#"res://levels/area01/01/tscn/treasurechest/PersistentDataHandler"
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name

#func _get_name() -> String:
	#if unique_id.strip_edges() != "":
		#return unique_id
	
	
	#var fallback = get_path()
	#push_warning("PersistentDataHandler on %s is missing a unique_id. Using fallback path." % fallback)
	#return fallback
