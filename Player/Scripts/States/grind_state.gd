class_name GrindState
extends BasePlayerState

func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Grind")


func validate_state(player: Player) -> void:
	if !player.grinding:
		player.change_state_to(PlayerStates.FALL)
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.JUMP)
