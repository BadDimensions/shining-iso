class_name InventoryData extends Resource

@export var slots : Array [ SlotData ]

func _init() -> void:
	connect_slots()
	pass
#func add_item(item : ItemData, count : int = 1) -> bool:
	#for s in slots:
		#if s:
			#if s.item_data == item:
				#s.quantity += count
				#return true
				
	#for i in slots.size():
		#if slots[i] == null:
			#var new = SlotData.new()
			#new.item_data = item
			#new.quantity = count
			#slots[i] = new
			#return true
	#print("inventory was full")				
	#return false				
	
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
