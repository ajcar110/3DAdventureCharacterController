class_name LedgeGrabComponent
extends Node3D

@export var h_offset: float = 0.5
@export var v_offset: float = 0.5
@onready var player = $".."
@onready var floor_raycast = $FloorRaycast
@onready var wall_raycast = $WallRaycast
@onready var ledge_fall_timer = $LedgeFallTimer

var edge_detected := false

func edge_detectiion():
	floor_raycast.force_raycast_update()
	if floor_raycast.is_colliding():
		var collision_position = floor_raycast.get_collision_point()
		wall_raycast.global_position.y = collision_position.y - 0.01
		
		wall_raycast.force_raycast_update()
		if wall_raycast.is_colliding():
			edge_detected = true
	else:
		edge_detected = false


func _on_ledge_fall_timer_timeout():
	floor_raycast.enabled = true
	wall_raycast.enabled = true
