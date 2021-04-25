extends RigidBody

var marker
var rayCastResult

func _ready():
	marker = get_node("Marker")

func _physics_process(delta):
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


func _on_Ball_body_shape_entered(body_id, body, body_shape, local_shape):
	print(body)
