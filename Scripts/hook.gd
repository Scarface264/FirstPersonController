extends RigidBody3D

var spawn = true

func _physics_process(_delta: float) -> void:
	if spawn == true:
		apply_torque_impulse(basis.x * 0.1)
		apply_impulse(basis.z * -25.0)
		spawn = false
		despawn()
		
func despawn():
	await get_tree().create_timer(5.0).timeout
