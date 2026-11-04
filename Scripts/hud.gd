
extends CanvasLayer
@onready var main_invent: Control = $MainInvent
#@onready var hud_panel: Panel = $Inventory
@onready var inventory_grid: GridContainer = $MainInvent/Inventory/MarginContainer/GridContainer
var slots: Array[InventorySlot] = []

func _ready() -> void:
	main_invent.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	for child in inventory_grid.get_children():
		if child is InventorySlot:
			slots.append(child)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		main_invent.visible = !main_invent.visible
		

		if main_invent.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
func add_item(item: ItemData) -> void:
	for slot in slots:
		if slot.item_data == null:
			slot.set_item(item)
			print("Added to inventory: ", item.name)
			return

	print("Inventory is full!")
