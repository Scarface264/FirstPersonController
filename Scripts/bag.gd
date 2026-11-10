extends RigidBody3D

var is_open := false

@onready var mesh: MeshInstance3D = $MeshInstance3D

var outline_material: ShaderMaterial



func _ready():
	outline_material = ShaderMaterial.new()
	outline_material.shader = preload("res://Shader/outline.gdshader")


func interact():
	open_chest()


func open_chest():
	if is_open:
		is_open = false
		print("Chest closed!")
		return

	is_open = true
	print("Chest opened!")

	
	
	
func set_highlight(enabled: bool):
	if enabled:
		mesh.material_overlay = outline_material
	else:
		mesh.material_overlay = null
