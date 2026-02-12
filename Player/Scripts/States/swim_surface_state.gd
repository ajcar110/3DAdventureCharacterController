class_name SwimSurfaceState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Swim")


func validate_state(player: Player) -> void:
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.SWIMJUMP)

	if player.get_horizontal_velocity() <= 0.1:
		player.change_state_to(PlayerStates.SWIMIDLE)

func tic(player: Player,delta: float) -> void:
	var dir = player.movement_component.move_dir
	var swim_speed = player.movement_component.swim_speed
	player.movement_component.apply_velocity_from_move_dir(dir,swim_speed)
	player.movement_component.turn_to(dir)
