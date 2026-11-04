extends Resource
class_name ItemData


@export var name: String = ""
@export var icon: Texture2D
@export var description: String = ""

func _init(p_name: String = "", p_description: String = "", p_icon: Texture2D = null):
	name = p_name
	icon = p_icon
	description = p_description 
