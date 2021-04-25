extends KinematicBody

export (Vector3) var startVel : Vector3 = Vector3()

var marker
var rayCastResult
var oldState

var vel

func _ready():
	marker = get_node("Marker")
	vel = startVel

func _physics_process(delta):
	var physicsSpeed = 1
	var gravity = 5
	var bounce = 1
	vel += Vector3(0, -1, 0) * gravity * delta * physicsSpeed
	
	var move = vel * delta
	
	while move.length() > 0.0001:
		var collision = move_and_collide(vel * delta * physicsSpeed)
		if collision:
			# Built in bounce way inconsistent. We'll have to do it ourselves.
			# Find ball speed relative to object and with the impact points normal
			# axis. Add 2*s*bounce to speed
			# TODO: Implement tourque
			var rVel = vel - collision.collider_velocity
			var rSpeed = rVel.dot(collision.normal)
			vel -= 2 * rSpeed * bounce * collision.normal
			
			move = collision.remainder
		else:
			break
	
	var space_state = get_world().direct_space_state
	var pos = self.translation + Vector3(0, 0.02, 0)
	rayCastResult = space_state.intersect_ray(pos, Vector3(pos.x, -1, pos.z), [self])

func _process(delta):
	if rayCastResult:
		marker.visible = true
		marker.global_transform.basis = Basis()
		marker.global_transform.origin = rayCastResult.position + Vector3(0, -0.04, 0)
	else:
		marker.visible = false

#func _integrate_forces(state):
#	for i in range(state.get_contact_count()):
#		print(state.get_contact_local_normal(i))
#		print(state.get_contact_impulse(i))
#		print(state.)
#		# var imp = state.get_contact_impulse(i)
#		# var adj = 0.01
#		# state.apply_central_impulse(state.get_contact_local_normal(i) * adj)
#	
#	oldState = state

func _on_Ball_body_shape_entered(body_id, body, body_shape, local_shape):
	pass
