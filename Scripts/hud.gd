
extends CanvasLayer

@onready var main_invent: Control = $MainInvent
@onready var player_invent: Control = $MainInvent/Inventory
@onready var chest_invent: Control = $MainInvent/Chest

@onready var inventory_grid: GridContainer = $MainInvent/Inventory/MarginContainer/GridContainer
@onready var chest_grid: GridContainer = $MainInvent/Chest/MarginContainer/GridContainer

var slots: Array[InventorySlot] = []
var chest_slots: Array[InventorySlot] = []

var active_chest: Chest = null


func _ready() -> void:
	add_to_group("hud")

	main_invent.hide()
	chest_invent.hide()

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Collect player inventory slots.
	for child in inventory_grid.get_children():
		if child is InventorySlot:
			slots.append(child)

	# Collect chest inventory slots.
	for child in chest_grid.get_children():
		if child is InventorySlot:
			chest_slots.append(child)

func _input(event: InputEvent) -> void:

	# Close chest when interact is pressed again.
	if event.is_action_pressed("interact") and active_chest != null:
		close_chest_ui()
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("inventory"):

		# If a chest is open, close it first.
		if active_chest != null:
			close_chest_ui()
			return

		main_invent.visible = !main_invent.visible

		if main_invent.visible:
			player_invent.show()
			chest_invent.hide()
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


# OPEN CHEST
func open_chest_ui(chest: Chest) -> void:

	# Save the previous chest if switching directly.
	if active_chest != null and active_chest != chest:
		save_chest_inventory()
		active_chest.is_open = false

	active_chest = chest

	# Make sure the chest has the correct number of slots.
	if active_chest.inventory_items.size() != chest_slots.size():
		active_chest.inventory_items.resize(chest_slots.size())

	# Load chest items into the UI.
	for i in range(chest_slots.size()):
		chest_slots[i].set_item(active_chest.inventory_items[i])

	main_invent.show()
	player_invent.show()
	chest_invent.show()

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# SAVE CHEST
func save_chest_inventory() -> void:
	if active_chest == null:
		return

	active_chest.inventory_items.clear()

	for slot in chest_slots:
		active_chest.inventory_items.append(slot.item_data)


# CLOSE CHEST
func close_chest_ui() -> void:
	if active_chest != null:
		save_chest_inventory()
		active_chest.is_open = false

	active_chest = null

	chest_invent.hide()
	main_invent.hide()

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
