class_name FallState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Fall")



func validate_state(player: Player) -> void:
	##Idle
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
		
	## WallRun
	if player.wall_run_component.wall_nearby() and player.input_component.grab_held:
		player.change_state_to(PlayerStates.WALLRUN)
		player.wall_run_component.start()
		player.wall_running = true

	## AirJump
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump()):
		player.change_state_to(PlayerStates.AIRJUMP)
