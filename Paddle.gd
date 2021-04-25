extends KinematicBody

var target
export (float) var distFromTarget : float = 1.5

var maxReachAng = Vector2(0.7, 0.2)
var basePos
var baseRot = Vector2(0, 0)
var targetTransform = Transform()
var baseAxis = Vector3(1, 0, 0)
var vertAxis = Vector3(0, 1, 0)
var sideAxis = vertAxis.cross(baseAxis)

func _ready():
	target = transform.origin
	basePos = baseToGlobal(Vector2())

func _physics_process(delta):
	var transSpeed = 12
	transform = transform.interpolate_with(targetTransform, transSpeed * delta)

func _process(delta):
	var leftJoy = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
	var rightJoy = Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3))
	
	var zVel = rightJoy.y * 0.1
	
	basePos = baseToGlobal(leftJoy, distFromTarget + zVel)
	baseRot = Vector2(leftJoy[0] * maxReachAng[0],leftJoy[1] * maxReachAng[1])
	
	targetTransform = Transform()
	targetTransform = targetTransform.rotated(vertAxis, 2 * baseRot.x)
	targetTransform = targetTransform.rotated(sideAxis, 2 * baseRot.y + PI/2)
	targetTransform.origin = basePos

# Convert left-joystick coordinates (-1:1) to global position
func baseToGlobal(coords, radius=distFromTarget):
	var pos = baseAxis * radius
	pos = pos.rotated(vertAxis, coords[0] * maxReachAng[0])
	pos = pos.rotated(sideAxis, coords[1] * maxReachAng[1])
	
	return target + pos
