class_name WallRunState
extends BasePlayerState



func  enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Walk")
	player.wall_run_component.start()
	player.wall_running = true
	
func validate_state(player: Player) -> void:
	if (!player.is_on_floor() and 
	!player.wall_run_component.wall_nearby() or 
	player.input_component.grab_released):
		player.change_state_to(PlayerStates.FALL)
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.WALLJUMP)
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
		
func tic(player: Player,delta: float) -> void:
	player.wall_run_component.tik()

func exit(p: Player) -> void:
	p.wall_running = false
