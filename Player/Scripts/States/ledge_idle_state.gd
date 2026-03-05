class_name LedgeIdleState
extends BasePlayerState



func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Idle")
	player.stop_moving()
	player.gravity_component.can_air_jump = true
	var collision_point = player.ledge_grab_component.wall_raycast.get_collision_point()
	var normal = player.ledge_grab_component.wall_raycast.get_collision_normal()
	player.position =(
		collision_point + player.basis.z
		* player.ledge_grab_component.h_offset
		)
	player.rotation.y = atan2(normal.x,normal.z)
	collision_point = player.ledge_grab_component.floor_raycast.get_collision_point()
	player.position.y = collision_point.y - player.ledge_grab_component.v_offset


func validate_state(player: Player) -> void:
	if player.input_component.cancel_pressed:
		player.change_state_to(PlayerStates.FALL)
		player.ledge_grab_component.ledge_fall_timer.start()
		player.ledge_grab_component.floor_raycast.enabled = false
		player.ledge_grab_component.wall_raycast.enabled = false
		player.ledge_grab_component.edge_detected = false
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.JUMP)
		
