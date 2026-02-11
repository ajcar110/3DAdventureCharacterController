class_name FallState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Fall")
	player.rail_grinding_component.grind_shape_cast.enabled = true
	player.trapeze_component.trapeze_shape.enabled = true


func validate_state(player: Player) -> void:
	##Idle
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
		
	## WallRun
	if player.wall_run_component.wall_nearby() and player.input_component.grab_held:
		player.change_state_to(PlayerStates.WALLRUN)
		
	## Trapeze
	if player.trapeze_component.trapeze_shape.is_colliding() and player.input_component.grab_held:
		player.change_state_to(PlayerStates.TRAPIDLESTATE)
	## AirJump
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.AIRJUMP)
	
	## RailGrind
	if player.rail_grinding_component.validate_grind():
		player.change_state_to(PlayerStates.GRIND)
	
func tic(player: Player,delta: float) -> void:
	player.movement_component.tik(delta)
