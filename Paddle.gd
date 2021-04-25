extends KinematicBody

var target
var distFromTarget = 1.5

var maxReachAng = Vector2(1.0, 0.5)
var basePos
var baseAxis = Vector3(1, 0, 0)

var time = 0

func _ready():
	target = transform.origin

func _physics_process(delta):
	var vel = Vector3(0, 0.2 * cos(time * 30), 0)
	time += delta
	
	var collision_info = move_and_collide(vel * delta)
	if collision_info:
		var collision_point = collision_info.position

func _process(delta):
	pass

# Convert left-joystick coordinates (-1:1) to global position
func baseToGlobal(coords):
	var pos = baseAxis * distFromTarget
	var vertAxis = Vector3(0, 1, 0)
	pos.rotated(vertAxis, coords[0] * maxReachAng[0])
	pos.rotated(vertAxis.cross(baseAxis), coords[1] * maxReachAng[1])
	
	return target + pos
