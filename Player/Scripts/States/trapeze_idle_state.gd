class_name TrapezeIdleState
extends BasePlayerState



func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/TrapezeIdle")
	player.stop_moving()
	player.trapeze_component.attatch_player(player)


func validate_state(player: Player) -> void:
	if !player.is_on_floor() and !player.input_component.grab_held:
		player.change_state_to(PlayerStates.FALL)
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.TRAPJUMPSTATE)
