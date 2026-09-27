extends RigidBody3D
@export var target: Node3D
@export var speed := 5.0


@onready var backpack: RigidBody3D = $Crate
@onready var zombie: RigidBody3D =$"."



func _ready():
	zombie.freeze= true
	backpack.freeze = true

func _physics_process(_delta):
	pass
	#var direction = global_position.direction_to(target.global_position)
	#linear_velocity = direction * speed
