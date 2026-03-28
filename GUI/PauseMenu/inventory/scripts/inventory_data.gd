class_name InventoryData extends Resource

@export var slots : Array [ SlotData ]

func _init() -> void:
	connect_slots()
	pass

func has_item(item: ItemData) -> bool:
	for s in slots:
		if s != null and s.item_data == item and s.quantity > 0:
			return true
	return false

	
func add_item(item: ItemData, count: int = 1) -> bool:
	var remaining = count
	
	for s in slots:
		if s and s.item_data == item:
			var space_left = item.max_stack - s.quantity
			if space_left > 0:
				var to_add = min(space_left, remaining)
				s.quantity += to_add
				remaining -= to_add
				
				if remaining <= 0:
					return true
	
	for i in range(slots.size()):
		if slots[i] == null:
			var new_slot = SlotData.new()
			new_slot.item_data = item
			
			var to_add = min(item.max_stack, remaining)
			new_slot.quantity = to_add
			
			slots[i] = new_slot
			remaining -= to_add
			new_slot.changed.connect(slot_changed) #this line could be problematic
			if remaining <= 0:
				return true
	
	return false

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)
	pass
	
func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots [index] = null
				emit_changed()
	pass

func get_save_data() -> Array:
	var item_save: Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save
	
func item_to_save( slot : SlotData ) -> Dictionary:
	var result = { item = "", quantity = 0}
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func parse_save_data( save_data:Array ) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize( array_size )
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
		connect_slots()
		pass

func item_from_save( save_object : Dictionary ) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot
