class_name IdleState
extends BasePlayerState



func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Idle")


func validate_state(player: Player) -> void:
	if !player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)
	
	if player.velocity.length() > 0.0:
		player.change_state_to(PlayerStates.WALK)
