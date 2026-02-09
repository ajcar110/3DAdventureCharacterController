class_name AirJumpState
extends BasePlayerState

func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Swing")
	player.gravity_component.jump()


func validate_state(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
	if player.velocity.y < 0.0:
		player.change_state_to(PlayerStates.FALL)
