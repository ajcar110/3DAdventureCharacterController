class_name MovementComponent
extends Node

@export var body: CharacterBody3D
@export var visuals: Node3D
@export var floor_ray: RayCast3D

@export_group("Movement")
@export var base_speed: float = 12.0
@export var acceleration: float = 0.5
@export var deceleration: float = 1.0
@export var top_walk_speed: float = 8.5


var move_dir: Vector3 = Vector3.ZERO
var xform: Transform3D


func tik(delta: float) -> void:
	if body == null:
		return
	
	apply_velocity_from_move_dir(move_dir)
	turn_to(move_dir)
	if body.is_on_floor():
		align_with_floor(floor_ray.get_collision_normal())
		body.global_transform = body.global_transform.interpolate_with(xform, 0.3)
	elif not body.is_on_floor():
		align_with_floor(Vector3.UP)
		body.global_transform = body.global_transform.interpolate_with(xform, 0.3)
	
	
func apply_velocity_from_move_dir(direction: Vector3, speed: float = base_speed) -> void:
	if direction:
		body.velocity.x = move_toward(body.velocity.x, speed * direction.x, acceleration)
		body.velocity.z = move_toward(body.velocity.z, speed * direction.z, acceleration)

	else:
		body.velocity.x = move_toward(body.velocity.x, 0, deceleration)
		body.velocity.z = move_toward(body.velocity.z, 0, deceleration)

func turn_to(direction: Vector3) -> void:
	if direction:
		var yaw := atan2(-direction.x,-direction.z)
		yaw = lerp_angle(body.rotation.y,yaw,.075)
		body.rotation.y = yaw

func align_with_floor(floor_normal):
	xform = body.global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
