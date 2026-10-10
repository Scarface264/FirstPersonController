
extends CanvasLayer

@onready var hud_panel: Panel = $Inventory

func _ready() -> void:
	hud_panel.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		hud_panel.visible = !hud_panel.visible

		if hud_panel.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
