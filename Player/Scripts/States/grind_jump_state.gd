class_name GrindJumpState
extends BasePlayerState


func enter(player: Player) -> void:
	player.rail_grinding_component.detach_from_rail()
	player.animation_player.play("PlayerAnimations/Jump")
	player.gravity_component.jump()
	
	var forward = -player.camera_component.global_transform.basis.z
	player.movement_component.apply_velocity_from_move_dir(forward,20.0)
	
	player.rail_grinding_component.grind_shape_cast.enabled = false
	player.grinding = false



func validate_state(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
	if player.velocity.y < 0.0:
		player.change_state_to(PlayerStates.FALL)
	## AirJump
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.AIRJUMP)
