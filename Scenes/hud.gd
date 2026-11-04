
extends CanvasLayer
@onready var main_invent: Control = $MainInvent
#@onready var hud_panel: Panel = $Inventory


func _ready() -> void:
	main_invent.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		main_invent.visible = !main_invent.visible
		

		if main_invent.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
