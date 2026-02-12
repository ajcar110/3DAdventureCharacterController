class_name SwimJumpState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Jump")
	player.gravity_component.swim_jump()



func validate_state(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
	if player.velocity.y < 0.0:
		player.change_state_to(PlayerStates.FALL)
	## AirJump
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.AIRJUMP)
	
	## Trapeze
	if player.trapeze_component.trapeze_shape.is_colliding():
		player.change_state_to(PlayerStates.TRAPIDLE)
	
