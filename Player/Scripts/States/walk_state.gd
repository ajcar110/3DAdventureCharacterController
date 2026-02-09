class_name WalkState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Run")


func validate_state(player: Player) -> void:
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump()):
		player.change_state_to(PlayerStates.JUMP)
		
	if not player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)
		
	if player.get_horizontal_velocity() <= 0.1:
		player.change_state_to(PlayerStates.IDLE)

func tic(player: Player,delta: float) -> void:
	var mov_dir = player.get_move_input()
	player.movement_component.apply_velocity_from_move_dir(mov_dir)
	player.movement_component.turn_to(mov_dir)
	player.move_and_slide()
