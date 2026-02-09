class_name AirJumpState
extends BasePlayerState

func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Swing")
	player.gravity_component.jump()
	player.gravity_component.can_air_jump = false


func validate_state(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
	if player.velocity.y < 0.0:
		player.change_state_to(PlayerStates.FALL)

func tic(player: Player,delta: float) -> void:
	player.movement_component.tik(delta)
