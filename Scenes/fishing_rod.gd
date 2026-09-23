extends Node3D

@export var cast_force := 15.0
@export var reel_force := 25.0
@export var reel_stop_distance := 0.3

@onready var bobber: RigidBody3D = $Bobber
@onready var rod: Node3D = $Rod
@onready var line: MeshInstance3D = $Line

var is_cast := false
var starting_local_position: Vector3


func _ready():
	# Remember where the bobber starts relative to the rod.
	starting_local_position = to_local(bobber.global_position)

	# Keep it there.
	bobber.freeze = true
	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	update_line()


func _process(_delta):
	if Input.is_action_just_pressed("cast") and not is_cast:
		cast()

	update_line()


func _physics_process(_delta):
	if is_cast and Input.is_action_pressed("reel"):
		reel_bobber()


func cast():
	is_cast = true

	# Convert the saved relative position back into world space.
	bobber.global_position = to_global(starting_local_position)

	bobber.freeze = false
	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	# Cast straight forward.
	var direction = -global_transform.basis.z

	bobber.apply_central_impulse(direction * cast_force)


func reel_bobber():
	# The original starting point, relative to the moving rod.
	var target = to_global(starting_local_position)

	var direction = target - bobber.global_position
	var distance = direction.length()

	if distance <= reel_stop_distance:
		finish_reel()
		return

	direction = direction.normalized()

	bobber.apply_central_force(direction * reel_force)


func finish_reel():
	is_cast = false

	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	# Return to its original position relative to the rod.
	bobber.global_position = to_global(starting_local_position)

	bobber.freeze = true

	update_line()


func update_line():
	var rod_position = rod.global_position
	var bobber_position = bobber.global_position

	var direction = bobber_position - rod_position
	var distance = direction.length()

	line.global_position = rod_position + direction / 2.0

	if distance > 0.01:
		line.scale.y = distance / 2.0
		line.look_at(bobber_position, Vector3.UP)
