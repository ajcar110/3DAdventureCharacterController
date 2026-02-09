class_name IdleState
extends BasePlayerState



func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Idle")


func validate_state(player: Player) -> void:
	if !player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.JUMP)
	
	if player.get_horizontal_velocity() > 0.01:
		player.change_state_to(PlayerStates.WALK)

func tic(player: Player,delta: float) -> void:
	player.movement_component.tik(delta)
