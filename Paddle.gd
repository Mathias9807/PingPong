extends KinematicBody

var target
export (float) var distFromTarget : float = 1.5

var maxReachAng = Vector2(0.7, 0.2)
var basePos
var baseRot = Vector2(0, 0)
var baseAxis = Vector3(1, 0, 0)
var vertAxis = Vector3(0, 1, 0)
var sideAxis = vertAxis.cross(baseAxis)

func _ready():
	target = transform.origin

func _physics_process(delta):
	var vel = Vector3(0, 0, 0)
	
	var collision_info = move_and_collide(vel * delta)
	if collision_info:
		var collision_point = collision_info.position

func _process(delta):
	transform = Transform()
	var leftJoy = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
	basePos = baseToGlobal(leftJoy)
	baseRot = Vector2(leftJoy[0] * maxReachAng[0], leftJoy[1] * maxReachAng[1])
	transform = transform.rotated(vertAxis, baseRot.x)
	transform = transform.rotated(sideAxis, baseRot.y + PI/2)
	transform.origin = basePos

# Convert left-joystick coordinates (-1:1) to global position
func baseToGlobal(coords):
	var pos = baseAxis * distFromTarget
	pos = pos.rotated(vertAxis, coords[0] * maxReachAng[0])
	pos = pos.rotated(sideAxis, coords[1] * maxReachAng[1])
	
	return target + pos
