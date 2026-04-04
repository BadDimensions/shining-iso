@tool
class_name DialogPortrait extends Sprite2D

var blink : bool = false : set = _set_blink
var open_mouth : bool = false : set = _set_open_mouth
var mouth_open_frames : int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	DialogSystem.letter_added.connect(check_mouth_open)
	blinker()
		
func check_mouth_open( l : String) -> void:
	if 'aeiouy123456789'.contains(l):
		open_mouth = true
		mouth_open_frames += 3
	elif '.,!?'.contains(l):
		mouth_open_frames = 0
		
	if mouth_open_frames > 0:
		mouth_open_frames -= 1
		
	if mouth_open_frames == 0:
		open_mouth = false
	pass
	
func update_potrait() -> void:
	if open_mouth == true:
		frame = 2
	else:
		frame = 0
	if blink == true:
		frame += 1
		
func _set_blink( _value : bool ) -> void:
	if blink != _value:
		blink = _value
		update_potrait()
	pass
		
func _set_open_mouth( _value : bool ) -> void:
	if open_mouth != _value:
		open_mouth = _value
		update_potrait()
	pass
	
func blinker() -> void:
	if blink == false:
		await get_tree().create_timer(randf_range(0.1, 3.0)).timeout
	else:
		await get_tree().create_timer(0.15).timeout
	blink = not blink
	blinker()
