extends Node3D

@export var cast_force := 15.0
@export var reel_force := 10.0
@export var reel_stop_distance := 0.3

@onready var bobber: RigidBody3D = $Bobber
@onready var rod: Node3D = $Rod
@onready var line: MeshInstance3D = $Line

var is_cast := false

# The bobber's starting position relative to the fishing rod.
var starting_local_position: Vector3

# The object currently caught by the bobber.
var caught_object: Node3D = null


func _ready():
	# Remember where the bobber starts relative to the rod.
	starting_local_position = to_local(bobber.global_position)

	# Keep the bobber in place until we cast.
	bobber.freeze = true
	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	# Enable collision detection.
	bobber.contact_monitor = true
	bobber.max_contacts_reported = 5

	# Detect when the bobber hits another physics body.
	if not bobber.body_entered.is_connected(_on_bobber_body_entered):
		bobber.body_entered.connect(_on_bobber_body_entered)

	update_line()


func _process(_delta):
	# Cast when the player presses the cast button.
	if Input.is_action_just_pressed("cast") and not is_cast:
		cast()

	# Keep the fishing line connected to the rod and bobber.
	update_line()


func _physics_process(_delta):
	# Reel while the reel button is being held.
	if is_cast and Input.is_action_pressed("reel"):
		reel_bobber()


# ============================================================
# CAST
# ============================================================

func cast():
	is_cast = true

	# Make sure there isn't an old caught object.
	caught_object = null

	# Put the bobber back at its starting position.
	bobber.global_position = to_global(starting_local_position)

	# Reset any previous movement.
	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	# Allow the bobber to move.
	bobber.freeze = false

	# Cast straight forward from the fishing rod.
	var direction := -global_transform.basis.z

	# Launch the bobber.
	bobber.apply_central_impulse(direction * cast_force)


# ============================================================
# REEL
# ============================================================

func reel_bobber():
	# Calculate the position the bobber needs to return to.
	var target := to_global(starting_local_position)

	var direction := target - bobber.global_position
	var distance := direction.length()

	# Stop when the bobber reaches the rod.
	if distance <= reel_stop_distance:
		finish_reel()
		return

	# Make sure we have a valid direction.
	if distance > 0.001:
		direction = direction.normalized()

	# Directly control the bobber's velocity while reeling.
	# This makes the reel much more predictable than applying
	# a constant force.
	bobber.linear_velocity = direction * reel_force

	# Prevent the bobber from spinning while being reeled.
	bobber.angular_velocity = Vector3.ZERO


# ============================================================
# BOBBER COLLISION
# ============================================================

func _on_bobber_body_entered(body: Node3D):
	# Don't catch anything if we're not casting.
	if not is_cast:
		return

	# Don't catch multiple objects.
	if caught_object != null:
		return

	# Only catch objects in the "catchable" group.
	if not body.is_in_group("catchable"):
		return

	catch_object(body)


# ============================================================
# CATCH OBJECT
# ============================================================

func catch_object(object: Node3D):
	caught_object = object

	# Save the object's exact position and rotation
	# before attaching it to the bobber.
	var caught_transform := object.global_transform

	# If the object is a RigidBody3D, stop its physics movement.
	if object is RigidBody3D or Node3D:
		object.freeze = true
		object.linear_velocity = Vector3.ZERO
		object.angular_velocity = Vector3.ZERO

	# Find every CollisionShape3D inside the caught object.
	var collision_shapes := object.find_children(
		"*",
		"CollisionShape3D",
		true,
		false
	)

	# Disable all of its collision shapes.
	for shape in collision_shapes:
		shape.disabled = true

	# Prevent the bobber from colliding with the caught object.
	if object is CollisionObject3D:
		bobber.add_collision_exception_with(object)

	# Stop the bobber when it catches something.
	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	# Attach the object to the bobber.
	#
	# "true" keeps the object's global transform while
	# changing its parent.
	object.reparent(bobber, true)

	# Restore the exact position where the object was caught.
	object.global_transform = caught_transform

	# Stop the object from moving relative to the bobber.
	if object is RigidBody3D:
		object.freeze = true
		object.linear_velocity = Vector3.ZERO
		object.angular_velocity = Vector3.ZERO


# ============================================================
# FINISH REEL
# ============================================================

func finish_reel():
	is_cast = false

	# Stop the bobber completely.
	bobber.linear_velocity = Vector3.ZERO
	bobber.angular_velocity = Vector3.ZERO

	# If we caught something, remove it.
	if caught_object != null:

		# Remove the collision exception first.
		if caught_object is CollisionObject3D:
			bobber.remove_collision_exception_with(caught_object)

		# Delete the caught object.
		caught_object.queue_free()

		caught_object = null

	# Return the bobber to its original position.
	bobber.global_position = to_global(starting_local_position)

	# Freeze the bobber again.
	bobber.freeze = true

	# Update the fishing line.
	update_line()


# ============================================================
# FISHING LINE
# ============================================================

func update_line():
	if not is_instance_valid(line):
		return

	if not is_instance_valid(rod):
		return

	if not is_instance_valid(bobber):
		return

	var rod_position := rod.global_position
	var bobber_position := bobber.global_position

	var direction := bobber_position - rod_position
	var distance := direction.length()

	# Put the center of the line halfway between
	# the rod and bobber.
	line.global_position = rod_position + direction / 2.0

	if distance > 0.01:
		# Assuming the Line mesh is a CylinderMesh oriented
		# along its Y axis.
		line.scale.y = distance / 2.0

		# Rotate the line so it points toward the bobber.
		line.look_at(bobber_position, Vector3.UP)
