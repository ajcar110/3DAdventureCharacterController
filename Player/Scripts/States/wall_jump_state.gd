class_name WallJumpState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Jump")
	player.gravity_component.jump()
	player.gravity_component.can_wall_jump = false



func validate_state(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
	if player.velocity.y < 0.0:
		player.change_state_to(PlayerStates.FALL)
	## AirJump
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.AIRJUMP)

func tic(player: Player,delta: float) -> void:
	player.movement_component.tik(delta)
