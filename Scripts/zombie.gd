extends CharacterBody3D

@export var target: Node3D
@export var speed := 5.0


@onready var backpack: RigidBody3D = $Crate2


@onready var backpack2: RigidBody3D = $Crate2/Crate

func _ready():
	backpack.freeze = true #makes backpack stick to zombie has to be child 
	backpack2.freeze = true


func _physics_process(_delta):
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * speed
	move_and_slide()
