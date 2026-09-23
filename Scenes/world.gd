extends Node3D
@onready var character = $Zombie
@onready var target = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character.target = target
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
