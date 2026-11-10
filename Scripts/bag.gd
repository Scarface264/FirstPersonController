
extends RigidBody3D
class_name Chest

var is_open := false

# Each chest has its own inventory.
@export var inventory_items: Array[ItemData] = []

@onready var mesh: MeshInstance3D = $MeshInstance3D

var outline_material: ShaderMaterial


func _ready() -> void:
	outline_material = ShaderMaterial.new()
	outline_material.shader = preload("res://Shader/outline.gdshader")


func interact() -> void:
	if is_open:
		close_chest()
	else:
		open_chest()


func open_chest() -> void:
	if is_open:
		return

	is_open = true

	var hud = get_tree().get_first_node_in_group("hud")

	if hud:
		hud.open_chest_ui(self)


func close_chest() -> void:
	if not is_open:
		return

	var hud = get_tree().get_first_node_in_group("hud")

	if hud:
		hud.close_chest_ui()
	else:
		is_open = false


func set_highlight(enabled: bool) -> void:
	if enabled:
		mesh.material_overlay = outline_material
	else:
		mesh.material_overlay = null
