extends Panel
class_name InventorySlot

@onready var icon: TextureRect = $Icon

var item_data: ItemData = null


# Set an item in this slot.
func set_item(item: ItemData) -> void:
	item_data = item

	if item_data != null:
		icon.texture = item_data.icon
	else:
		icon.texture = null


# Start dragging an item.
func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_data == null:
		return null

	var preview = duplicate()
	var container = Control.new()

	container.add_child(preview)
	preview.position = Vector2(-25, -25)
	preview.modulate = Color(1, 1, 1, 0.5)

	set_drag_preview(container)

	return self


# Check whether another slot can receive this item.
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot and data != self


# Swap items between slots.
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var source = data as InventorySlot

	var temp: ItemData = item_data

	set_item(source.item_data)
	source.set_item(temp)
