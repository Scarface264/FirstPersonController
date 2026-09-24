extends CharacterBody3D

@export var target: Node3D
@export var speed := 5.0

func _physics_process(_delta):
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * speed
	move_and_slide()
