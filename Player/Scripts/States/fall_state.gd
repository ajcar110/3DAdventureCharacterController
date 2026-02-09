class_name FallState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Fall")



func validate_state(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
	if player.wall_run_component.wall_nearby() and player.input_component.grab_held:
		player.change_state_to(PlayerStates.WALLRUN)
		player.wall_run_component.start()
		player.wall_running = true
