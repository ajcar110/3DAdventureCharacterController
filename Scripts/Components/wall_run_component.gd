class_name WallRunComponent
extends Node3D

@export var body: Player
@export var visuals: Node3D
@export var ray_left: RayCast3D
@export var ray_right: RayCast3D

@export_category("Settings")
@export var wall_run_speed: float = 14.0

var wall_normal: Vector3
var direction: Vector3 = Vector3.ZERO
var xform: Transform3D

func wall_nearby():
	return ray_left.is_colliding() or ray_right.is_colliding()
	
func start():
	if not body.wall_running:
		body.velocity.y = 0.0

func tik():
	if wall_nearby():
		
		var collision_distance
		var distance_offset := 0.2
		
		xform = body.global_transform
		
		if ray_right.is_colliding():
			wall_normal = ray_right.get_collision_normal()
			xform.basis.x  = -wall_normal
			collision_distance = ray_right.get_collision_point().distance_to(global_position) - distance_offset
			
			visuals.rotation_degrees.z = 45
			
		elif ray_left.is_colliding():
			wall_normal = ray_left.get_collision_normal()
			xform.basis.x  = wall_normal
			collision_distance = ray_left.get_collision_point().distance_to(global_position) - distance_offset
		
			visuals.rotation_degrees.z = -45
			
		visuals.position = collision_distance * -wall_normal
		
		xform.basis = xform.basis.orthonormalized()
		body.global_transform = body.global_transform.interpolate_with(xform,0.3)
		
		var direction_velocity = direction * wall_run_speed
		var parallelVelocity = direction_velocity - wall_normal * direction_velocity.dot(wall_normal)
		body.velocity.x = parallelVelocity.x
		body.velocity.z = parallelVelocity.z
