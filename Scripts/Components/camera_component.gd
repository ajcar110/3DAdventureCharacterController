class_name CameraComponent
extends SpringArm3D

@export var player: Player
@export var turn_rate: int = 140
@export var mouse_sens: float = .10
@onready var camera : Camera3D = $Camera3D
var player_tp_distace: float = 0.0
var mouse_input: Vector2 = Vector2.ZERO
var init_rotation: Vector3
var offset: Vector3


func _ready():
	spring_length = camera.position.z
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	init_rotation = rotation_degrees
	offset = self.position

func _process(delta):
	var look_input := Input.get_vector("camera_right","camera_left","camera_down","camera_up")
	look_input *= turn_rate * delta
	look_input += mouse_input
	mouse_input = Vector2.ZERO
	rotation_degrees.x += look_input.y
	rotation_degrees.y += look_input.x
	rotation_degrees.x = clampf(rotation_degrees.x,-15,17)

@warning_ignore("unused_parameter")
func _physics_process(delta):
	position = player.position + offset
	

func _input(event)-> void:
	if event is InputEventMouseMotion:
		mouse_input = -event.relative * mouse_sens
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
